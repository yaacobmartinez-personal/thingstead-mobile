// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the intro has been seen. Shown once on a fresh install; Account
/// can bring it back.

@ProviderFor(OnboardingSeen)
final onboardingSeenProvider = OnboardingSeenProvider._();

/// Whether the intro has been seen. Shown once on a fresh install; Account
/// can bring it back.
final class OnboardingSeenProvider
    extends $NotifierProvider<OnboardingSeen, bool> {
  /// Whether the intro has been seen. Shown once on a fresh install; Account
  /// can bring it back.
  OnboardingSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingSeenHash();

  @$internal
  @override
  OnboardingSeen create() => OnboardingSeen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingSeenHash() => r'3c71b43e15d79d85806fe0d6884dd006ce8f56e5';

/// Whether the intro has been seen. Shown once on a fresh install; Account
/// can bring it back.

abstract class _$OnboardingSeen extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
