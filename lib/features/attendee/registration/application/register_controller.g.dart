// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Registers the signed-in person (API-CONTRACT #13) and refreshes the
/// public event (places left) and the ticket list afterwards.

@ProviderFor(RegisterController)
final registerControllerProvider = RegisterControllerProvider._();

/// Registers the signed-in person (API-CONTRACT #13) and refreshes the
/// public event (places left) and the ticket list afterwards.
final class RegisterControllerProvider
    extends $NotifierProvider<RegisterController, void> {
  /// Registers the signed-in person (API-CONTRACT #13) and refreshes the
  /// public event (places left) and the ticket list afterwards.
  RegisterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerControllerHash();

  @$internal
  @override
  RegisterController create() => RegisterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$registerControllerHash() =>
    r'847c07767d5e9eb5a55004e3594aab4d1fabe094';

/// Registers the signed-in person (API-CONTRACT #13) and refreshes the
/// public event (places left) and the ticket list afterwards.

abstract class _$RegisterController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
