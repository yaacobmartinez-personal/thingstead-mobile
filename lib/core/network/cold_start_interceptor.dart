import 'package:dio/dio.dart';

/// Retries requests that fail the way a sleeping server fails — connection
/// refused, connect/receive timeouts, 502/503 from the edge — a few times with
/// a pause, and reports "waking" so the UI can say so.
///
/// Retrying a POST is safe here: every write the app makes is idempotent on
/// the server (login, check-in, registration with a unique email, toggles).
class ColdStartInterceptor extends Interceptor {
  ColdStartInterceptor({
    required this.dio,
    required this.onWaking,
    this.maxRetries = 3,
    this.delay = const Duration(seconds: 5),
  });

  final Dio dio;
  final void Function(bool waking) onWaking;
  final int maxRetries;
  final Duration delay;

  static const _attemptKey = 'coldStartAttempt';

  static bool looksAsleep(DioException e) => switch (e.type) {
        DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          true,
        DioExceptionType.badResponse =>
          const {502, 503, 504}.contains(e.response?.statusCode),
        _ => false,
      };

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!looksAsleep(err)) return handler.next(err);

    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;
    if (attempt >= maxRetries) {
      onWaking(false);
      return handler.next(err);
    }

    onWaking(true);
    await Future<void>.delayed(delay);

    final options = err.requestOptions..extra[_attemptKey] = attempt + 1;
    try {
      final response = await dio.fetch<dynamic>(options);
      onWaking(false);
      handler.resolve(response);
    } on DioException catch (e) {
      // The nested fetch already exhausted its own retries.
      if (attempt == 0) onWaking(false);
      handler.next(e);
    }
  }
}
