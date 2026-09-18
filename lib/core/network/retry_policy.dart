import 'api_error.dart';

/// Riverpod 3 retries failed providers with backoff by default. Only transport
/// failures deserve a retry; a 401/403/404 would just hammer the server.
/// Installed on the root `ProviderScope` and on test containers, so a
/// provider that fails with a 404 rejects its `.future` immediately.
Duration? appRetryPolicy(int retryCount, Object error) {
  if (error is ApiError && error.isNetwork && retryCount < 3) {
    return Duration(seconds: 2 << retryCount);
  }
  return null;
}
