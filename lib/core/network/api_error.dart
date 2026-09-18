import 'package:dio/dio.dart';

/// Thrown for any non-2xx response or transport failure so callers can branch
/// on [status]. `status == 0` means the server could not be reached at all.
///
/// Messages mirror regista/mobile/src/api.ts so both apps read the same.
class ApiError implements Exception {
  ApiError(
    this.status,
    this.message, {
    Map<String, String>? fieldErrors,
    this.reason,
  }) : fieldErrors = fieldErrors ?? const {};

  factory ApiError.network() => ApiError(0, networkMessage);

  /// Not implemented on this server yet (see docs/API-CONTRACT.md).
  factory ApiError.notAvailable() =>
      ApiError(501, 'Not available on this server yet.');

  /// Build from a decoded response body, applying the standard fallbacks.
  factory ApiError.fromResponse(int status, Object? body) {
    final map = body is Map<String, dynamic> ? body : const <String, dynamic>{};
    final message = switch (map['error']) {
      final String s when s.isNotEmpty => s,
      _ => defaultMessage(status),
    };
    final fields = <String, String>{};
    if (map['fieldErrors'] is Map) {
      (map['fieldErrors'] as Map).forEach((k, v) {
        if (v is String) fields['$k'] = v;
      });
    }
    return ApiError(
      status,
      message,
      fieldErrors: fields,
      reason: map['reason'] is String ? map['reason'] as String : null,
    );
  }

  factory ApiError.fromDio(DioException e) {
    final response = e.response;
    if (response == null) return ApiError.network();
    return ApiError.fromResponse(response.statusCode ?? 0, response.data);
  }

  static const networkMessage =
      "Can't reach the server. Check the address and your connection.";

  static String defaultMessage(int status) => switch (status) {
        401 => 'Your session has expired. Sign in again.',
        403 => "You don't have access to that.",
        _ => 'Something went wrong. Try again.',
      };

  final int status;
  final String message;

  /// Per-field validation messages from a 400, keyed by field name.
  final Map<String, String> fieldErrors;

  /// Machine-readable reason some endpoints add (e.g. `sole_admin`,
  /// `email_mismatch`, `last_admin`).
  final String? reason;

  bool get isNetwork => status == 0;
  bool get isUnauthorized => status == 401;
  bool get isForbidden => status == 403;
  bool get isNotFound => status == 404;

  @override
  String toString() => 'ApiError($status, $message)';
}
