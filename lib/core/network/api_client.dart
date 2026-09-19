import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../storage/boot_data.dart';
import '../time/clock.dart';
import 'api_error.dart';
import 'cold_start_interceptor.dart';
import 'token_codec.dart';
import 'unauthorized_events.dart';

part 'api_client.g.dart';

/// Thin JSON client over Dio that every `Real*Repository` uses.
///
/// - Adds the bearer token (read lazily per request, so the client is not
///   rebuilt on every auth change).
/// - Maps every failure to [ApiError]; `status == 0` is "could not reach".
/// - Emits on [UnauthorizedEvents] for any 401 except the login call itself
///   (a 401 there just means wrong password).
class ApiClient {
  ApiClient({
    required this._dio,
    required this._token,
    required this._unauthorized,
  });

  final Dio _dio;
  final String? Function() _token;
  final UnauthorizedEvents _unauthorized;

  /// Paths whose 401 is a business outcome, not an expired session.
  static const _loginPaths = {
    '/mobile/auth/login',
    '/mobile/auth/google',
    '/mobile/auth/apple',
  };

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _json(path, method: 'GET', query: query);

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _json(path, method: 'POST', body: body);

  Future<Map<String, dynamic>> patch(String path, {Object? body}) =>
      _json(path, method: 'PATCH', body: body);

  Future<Map<String, dynamic>> delete(String path, {Object? body}) =>
      _json(path, method: 'DELETE', body: body);

  /// Raw bytes plus the response headers (CSV export).
  Future<(List<int>, Headers)> getBytes(String path) async {
    final response = await _send<List<int>>(
      path,
      method: 'GET',
      responseType: ResponseType.bytes,
    );
    return (response.data ?? const <int>[], response.headers);
  }

  Future<Map<String, dynamic>> _json(
    String path, {
    required String method,
    Map<String, dynamic>? query,
    Object? body,
  }) async {
    final response = await _send<dynamic>(
      path,
      method: method,
      query: query,
      body: body,
      responseType: ResponseType.json,
    );
    final data = response.data;
    if (data == null || (data is String && data.isEmpty)) return const {};
    if (data is Map<String, dynamic>) return data;
    throw ApiError(
      response.statusCode ?? 0,
      'Unexpected response from the server.',
    );
  }

  Future<Response<T>> _send<T>(
    String path, {
    required String method,
    Map<String, dynamic>? query,
    Object? body,
    required ResponseType responseType,
  }) async {
    final token = _token();
    try {
      return await _dio.request<T>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          responseType: responseType,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      final error = ApiError.fromDio(e);
      if (error.isUnauthorized && !_loginPaths.contains(path)) {
        _unauthorized.emit();
      }
      throw error;
    }
  }
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.defaultServerUrl}/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'X-Client': 'thingstead-flutter/${AppConfig.appVersion} '
            '(${Platform.operatingSystem})',
      },
      // Let non-2xx through to our own mapping rather than Dio's.
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ),
  );
  dio.interceptors.add(
    ColdStartInterceptor(
      dio: dio,
      onWaking: (waking) => ref.read(serverWakingProvider.notifier).set(waking),
    ),
  );

  return ApiClient(
    dio: dio,
    token: () => ref.read(currentTokenProvider),
    unauthorized: ref.watch(unauthorizedEventsProvider),
  );
}

/// The bearer token to send, or null. Seeded from persisted boot data (when
/// unexpired), then owned by the auth controller. Kept as its own tiny
/// provider so the API client does not depend on auth state.
@Riverpod(keepAlive: true)
class CurrentToken extends _$CurrentToken {
  @override
  String? build() {
    final token = ref.watch(bootDataProvider).token;
    if (token == null) return null;
    final expiry = TokenCodec.expiry(token);
    final now = ref.read(clockProvider)();
    return expiry != null && expiry.isAfter(now) ? token : null;
  }

  void set(String? token) => state = token;
}

/// The signed-in user's id, decoded from the current token (null when signed
/// out). Fake repositories use it to scope their answers the way the server
/// scopes by `sub`.
@riverpod
String? currentUserId(Ref ref) {
  final token = ref.watch(currentTokenProvider);
  return token == null ? null : TokenCodec.subject(token);
}
