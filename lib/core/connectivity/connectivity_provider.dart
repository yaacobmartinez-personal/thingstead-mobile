import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Whether the device reports a network. A hint, never a guarantee: the app
/// still tries requests when this says online, and treats a transport
/// failure as offline when this says otherwise. Overridden in tests.
@Riverpod(keepAlive: true)
Stream<bool> connectivity(Ref ref) async* {
  final c = Connectivity();
  yield _online(await c.checkConnectivity());
  yield* c.onConnectivityChanged.map(_online);
}

bool _online(List<ConnectivityResult> results) =>
    results.any((r) => r != ConnectivityResult.none);

/// Current best guess; optimistic until the first reading arrives.
@Riverpod(keepAlive: true)
bool isOnline(Ref ref) => ref.watch(connectivityProvider).value ?? true;
