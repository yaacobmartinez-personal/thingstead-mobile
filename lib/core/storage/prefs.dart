import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';

/// Non-secret preferences: which shell was last used, the selected org, and
/// recently opened org codes.
class Prefs {
  Prefs([SharedPreferencesAsync? prefs]) : _injected = prefs;

  final SharedPreferencesAsync? _injected;

  // Created on first use so test doubles that override every method never
  // touch the platform plugin.
  late final SharedPreferencesAsync _prefs = _injected ?? SharedPreferencesAsync();

  static const keyAppMode = 'appMode';
  static const keySelectedOrg = 'selectedOrg';
  static const keyRecentOrgs = 'recentOrgs';

  Future<String?> getString(String key) async {
    try {
      return await _prefs.getString(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> setString(String key, String? value) async {
    try {
      if (value == null) {
        await _prefs.remove(key);
      } else {
        await _prefs.setString(key, value);
      }
    } catch (_) {}
  }

  Future<List<String>> getStringList(String key) async {
    try {
      return await _prefs.getStringList(key) ?? const [];
    } catch (_) {
      return const [];
    }
  }

  Future<void> setStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
Prefs prefs(Ref ref) => Prefs();
