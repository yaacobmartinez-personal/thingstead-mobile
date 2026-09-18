import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../storage/boot_data.dart';
import '../storage/secure_store.dart';

part 'server_url.g.dart';

/// Trim whitespace and trailing slashes so paths can be appended safely.
/// Port of `normalizeServerUrl` in regista/mobile/src/config.ts.
String normalizeServerUrl(String raw) =>
    raw.trim().replaceAll(RegExp(r'/+$'), '');

final _urlShape = RegExp(r'^https?://.+', caseSensitive: false);

bool isValidServerUrl(String raw) => _urlShape.hasMatch(raw.trim());

/// Which Thingstead deployment the app talks to. Per-install so one build
/// works against the live site, a staging box, or a laptop on the same Wi-Fi.
@Riverpod(keepAlive: true)
class ServerUrl extends _$ServerUrl {
  @override
  String build() {
    final stored = ref.watch(bootDataProvider).serverUrl;
    return stored == null || stored.isEmpty
        ? AppConfig.defaultServerUrl
        : normalizeServerUrl(stored);
  }

  bool get isDefault => state == AppConfig.defaultServerUrl;

  /// Persist and switch. Callers that hold a session must sign out: a token
  /// minted by one server means nothing to another.
  Future<void> set(String raw) async {
    final next = normalizeServerUrl(raw.isEmpty ? AppConfig.defaultServerUrl : raw);
    await ref.read(secureStoreProvider).write(SecureStore.keyServerUrl, next);
    state = next;
  }

  /// Host shown in the login footer ("Server: thingstead.onrender.com").
  String get host => state.replaceFirst(RegExp(r'^https?://', caseSensitive: false), '');
}
