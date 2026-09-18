import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_mode_controller.g.dart';

/// Which side of the app the person is using. Attendee is the default; the
/// organizer shell is offered once the signed-in user has an org membership.
enum AppMode {
  attendee('/a/events'),
  organizer('/o/events');

  const AppMode(this.home);

  /// The route each shell opens on.
  final String home;
}

@Riverpod(keepAlive: true)
class AppModeController extends _$AppModeController {
  @override
  AppMode build() => AppMode.attendee;

  void set(AppMode mode) => state = mode;
}
