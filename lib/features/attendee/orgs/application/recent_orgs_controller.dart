import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/prefs.dart';
import '../domain/public_org.dart';

part 'recent_orgs_controller.g.dart';

/// Orgs the person has opened, newest first, so the Find tab offers them
/// back without a directory (discovery is links and codes only). Persisted
/// as JSON strings in prefs; capped so the list stays a shortcut.
@Riverpod(keepAlive: true)
class RecentOrgs extends _$RecentOrgs {
  static const max = 5;

  @override
  Future<List<PublicOrg>> build() async {
    final raw = await ref.watch(prefsProvider).getStringList(Prefs.keyRecentOrgs);
    return [for (final s in raw) ?_decode(s)];
  }

  static PublicOrg? _decode(String s) {
    try {
      final json = jsonDecode(s);
      if (json is Map<String, dynamic> && json['slug'] is String && json['name'] is String) {
        return PublicOrg.fromJson(json);
      }
    } catch (_) {}
    return null;
  }

  /// Waits for the persisted list if it is still loading, so an early call
  /// (the first org page opening) is not overwritten when the load lands.
  Future<void> remember(PublicOrg org) async {
    final current = await future;
    final next = [org, ...current.where((o) => o.slug != org.slug)].take(max).toList();
    state = AsyncData(next);
    await _persist(next);
  }

  Future<void> forget(String slug) async {
    final next = (await future).where((o) => o.slug != slug).toList();
    state = AsyncData(next);
    await _persist(next);
  }

  Future<void> _persist(List<PublicOrg> orgs) => ref.read(prefsProvider).setStringList(
        Prefs.keyRecentOrgs,
        [for (final o in orgs) jsonEncode(o.toJson())],
      );
}
