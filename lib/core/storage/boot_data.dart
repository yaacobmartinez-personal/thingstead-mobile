import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/user.dart';
import '../../features/organizer/orgs/domain/org.dart';
import 'prefs.dart';
import 'secure_store.dart';

part 'boot_data.g.dart';

/// Everything persisted that the first frame needs, read once in `main()` so
/// auth state, server address and app mode are known synchronously and the
/// router never has to show a splash screen.
class BootData {
  const BootData({
    this.token,
    this.user,
    this.orgs = const [],
    this.serverUrl,
    this.appMode,
    this.selectedOrgSlug,
    this.appearance,
    this.onboardingSeen = false,
    this.organizeIntent = false,
  });

  static const empty = BootData();

  final String? token;
  final User? user;
  final List<Org> orgs;
  final String? serverUrl;
  final String? appMode;
  final String? selectedOrgSlug;

  /// 'system' | 'light' | 'dark'; null = system.
  final String? appearance;
  final bool onboardingSeen;

  /// Set at signup when the person chose "Organize events"; consumed after
  /// their email is verified to route them into organization setup.
  final bool organizeIntent;

  static Future<BootData> load(SecureStore secure, Prefs prefs) async {
    final token = await secure.read(SecureStore.keyToken);
    final userJson = await secure.readJson(SecureStore.keyUser);
    final orgsJson = await secure.readJsonList(SecureStore.keyOrgs);

    User? user;
    try {
      if (userJson != null) user = User.fromJson(userJson);
    } catch (_) {
      user = null;
    }

    var orgs = const <Org>[];
    try {
      if (orgsJson != null) {
        orgs = orgsJson
            .whereType<Map<String, dynamic>>()
            .map(Org.fromJson)
            .toList(growable: false);
      }
    } catch (_) {
      orgs = const [];
    }

    return BootData(
      token: token,
      user: user,
      orgs: orgs,
      serverUrl: await secure.read(SecureStore.keyServerUrl),
      appMode: await prefs.getString(Prefs.keyAppMode),
      selectedOrgSlug: await prefs.getString(Prefs.keySelectedOrg),
      appearance: await prefs.getString(Prefs.keyAppearance),
      onboardingSeen: (await prefs.getString(Prefs.keyOnboardingSeen)) == 'true',
      organizeIntent: (await prefs.getString(Prefs.keyOrganizeIntent)) == 'true',
    );
  }
}

/// Overridden in `main()` with the loaded snapshot; tests override it with
/// whatever starting state they need.
@Riverpod(keepAlive: true)
BootData bootData(Ref ref) => BootData.empty;
