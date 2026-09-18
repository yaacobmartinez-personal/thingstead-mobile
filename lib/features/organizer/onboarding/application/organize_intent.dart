import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/boot_data.dart';
import '../../../../core/storage/prefs.dart';

part 'organize_intent.g.dart';

/// "I'm here to organize events", chosen at signup. Persisted because the
/// verification step may come back through an emailed link (or a relaunch),
/// so nothing in memory survives to the point where it is needed.
@Riverpod(keepAlive: true)
class OrganizeIntent extends _$OrganizeIntent {
  @override
  bool build() => ref.watch(bootDataProvider).organizeIntent;

  void set(bool value) {
    if (state == value) return;
    state = value;
    ref.read(prefsProvider).setString(Prefs.keyOrganizeIntent, value ? 'true' : null);
  }
}
