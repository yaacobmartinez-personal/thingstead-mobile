import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:thingstead/core/config/api_mode.dart';
import 'package:thingstead/core/config/app_config.dart';
import 'package:thingstead/core/fake/fake_latency.dart';
import 'package:thingstead/core/fake/fake_providers.dart';
import 'package:thingstead/core/fake/fake_store.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/storage/boot_data.dart';
import 'package:thingstead/core/storage/prefs.dart';
import 'package:thingstead/core/storage/secure_store.dart';
import 'package:thingstead/core/time/clock.dart';

/// Secure storage that never touches the platform.
class InMemorySecureStore extends SecureStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}

class InMemoryPrefs extends Prefs {
  final values = <String, Object>{};

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<void> setString(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<List<String>> getStringList(String key) async =>
      (values[key] as List<String>?) ?? const [];

  @override
  Future<void> setStringList(String key, List<String> value) async {
    values[key] = value;
  }
}

/// A fixed "now" for deterministic seeds and expiries.
final testNow = DateTime.utc(2026, 9, 18, 12);

/// The standard test world: fake API mode, zero latency, a freshly seeded
/// store, in-memory storage, and a pinned clock.
class TestWorld {
  TestWorld({BootData boot = BootData.empty, DateTime? now})
      : now = now ?? testNow,
        secure = InMemorySecureStore(),
        prefs = InMemoryPrefs(),
        store = FakeStore() {
    seedFakeStore(store, this.now);
    overrides = [
      apiModeProvider.overrideWithValue(ApiMode.fake),
      clockProvider.overrideWithValue(() => this.now),
      fakeLatencyProvider.overrideWithValue(FakeLatency.none),
      fakeStoreProvider.overrideWithValue(store),
      secureStoreProvider.overrideWithValue(secure),
      prefsProvider.overrideWithValue(prefs),
      bootDataProvider.overrideWithValue(boot),
    ];
  }

  final DateTime now;
  final InMemorySecureStore secure;
  final InMemoryPrefs prefs;
  final FakeStore store;
  late final List<Override> overrides;

  ProviderContainer container() {
    final c = ProviderContainer(overrides: overrides);
    return c;
  }
}
