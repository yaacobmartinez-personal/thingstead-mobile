import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../time/clock.dart';
import 'fake_latency.dart';
import 'fake_store.dart';
import 'seed.dart';

part 'fake_providers.g.dart';

/// The one shared fake world. Seeded once per app run; tests override this
/// with a store of their own.
@Riverpod(keepAlive: true)
FakeStore fakeStore(Ref ref) {
  final store = FakeStore();
  seedFakeStore(store, ref.read(clockProvider)());
  return store;
}

@Riverpod(keepAlive: true)
FakeLatency fakeLatency(Ref ref) => const FakeLatency();
