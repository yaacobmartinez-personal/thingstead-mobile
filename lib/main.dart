import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'app.dart';
import 'core/network/api_error.dart';
import 'core/time/app_time.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
  runApp(
    ProviderScope(
      retry: _retryPolicy,
      child: const ThingsteadApp(),
    ),
  );
}

/// Work that must finish before the first frame: the timezone database and
/// the device zone. Storage and the local database are opened lazily by
/// their providers.
Future<void> _bootstrap() async {
  AppTime.ensureInitialized();
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    if (AppTime.isValidTimeZone(zone.identifier)) {
      AppTime.deviceZone = zone.identifier;
    }
  } catch (_) {
    // Keep the UTC fallback; the device zone only affects display defaults.
  }
}

/// Riverpod 3 retries failed providers with backoff by default. Only transport
/// failures deserve a retry; a 401/403/404 would just hammer the server.
Duration? _retryPolicy(int retryCount, Object error) {
  if (error is ApiError && error.isNetwork && retryCount < 3) {
    return Duration(seconds: 2 << retryCount);
  }
  return null;
}
