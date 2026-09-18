import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unauthorized_events.g.dart';

/// A one-way channel from the API client to the auth controller. The client
/// must not touch auth state directly (that would make a provider cycle:
/// auth -> repositories -> client -> auth), so it emits here and the auth
/// controller listens and signs out.
class UnauthorizedEvents {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void emit() {
    if (!_controller.isClosed) _controller.add(null);
  }

  void dispose() => _controller.close();
}

@Riverpod(keepAlive: true)
UnauthorizedEvents unauthorizedEvents(Ref ref) {
  final events = UnauthorizedEvents();
  ref.onDispose(events.dispose);
  return events;
}

/// True while a request is being retried because the server looks asleep
/// (Render's free tier cold-starts in 30–60 s). Screens show "Waking the
/// server…" instead of a raw timeout.
@Riverpod(keepAlive: true)
class ServerWaking extends _$ServerWaking {
  @override
  bool build() => false;

  void set(bool value) {
    if (state != value) state = value;
  }
}
