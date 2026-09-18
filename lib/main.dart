import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'app.dart';
import 'core/network/retry_policy.dart';
import 'core/storage/boot_data.dart';
import 'core/storage/prefs.dart';
import 'core/storage/secure_store.dart';
import 'core/time/app_time.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final boot = await _bootstrap();
  runApp(
    ProviderScope(
      retry: appRetryPolicy,
      overrides: [bootDataProvider.overrideWithValue(boot)],
      child: const ThingsteadApp(),
    ),
  );
}

/// Work that must finish before the first frame: the timezone database, the
/// device zone, and the persisted session so the router never needs a
/// splash screen. Every read is defensive; a broken store reads as signed out.
Future<BootData> _bootstrap() async {
  AppTime.ensureInitialized();
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    if (AppTime.isValidTimeZone(zone.identifier)) {
      AppTime.deviceZone = zone.identifier;
    }
  } catch (_) {
    // Keep the UTC fallback; the device zone only affects display defaults.
  }
  try {
    return await BootData.load(SecureStore(), Prefs());
  } catch (_) {
    return BootData.empty;
  }
}

