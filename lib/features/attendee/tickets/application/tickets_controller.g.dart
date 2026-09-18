// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Rebuilds on sign-in/out so another account never sees a stale list.

@ProviderFor(TicketsController)
final ticketsControllerProvider = TicketsControllerProvider._();

/// Rebuilds on sign-in/out so another account never sees a stale list.
final class TicketsControllerProvider
    extends $AsyncNotifierProvider<TicketsController, TicketsState> {
  /// Rebuilds on sign-in/out so another account never sees a stale list.
  TicketsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsControllerHash();

  @$internal
  @override
  TicketsController create() => TicketsController();
}

String _$ticketsControllerHash() => r'2210d5a00390fea29b80beff9a8ebca820fc4826';

/// Rebuilds on sign-in/out so another account never sees a stale list.

abstract class _$TicketsController extends $AsyncNotifier<TicketsState> {
  FutureOr<TicketsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TicketsState>, TicketsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TicketsState>, TicketsState>,
              AsyncValue<TicketsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// One ticket (#15); the list is the usual source, the fetch covers deep
/// links and a fresh registration.

@ProviderFor(ticket)
final ticketProvider = TicketFamily._();

/// One ticket (#15); the list is the usual source, the fetch covers deep
/// links and a fresh registration.

final class TicketProvider
    extends $FunctionalProvider<AsyncValue<Ticket>, Ticket, FutureOr<Ticket>>
    with $FutureModifier<Ticket>, $FutureProvider<Ticket> {
  /// One ticket (#15); the list is the usual source, the fetch covers deep
  /// links and a fresh registration.
  TicketProvider._({
    required TicketFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ticketProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketHash();

  @override
  String toString() {
    return r'ticketProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Ticket> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Ticket> create(Ref ref) {
    final argument = this.argument as String;
    return ticket(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TicketProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketHash() => r'bc9f1c604f06b2cd33075955175a8a3014a6bcb1';

/// One ticket (#15); the list is the usual source, the fetch covers deep
/// links and a fresh registration.

final class TicketFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Ticket>, String> {
  TicketFamily._()
    : super(
        retry: null,
        name: r'ticketProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One ticket (#15); the list is the usual source, the fetch covers deep
  /// links and a fresh registration.

  TicketProvider call(String id) => TicketProvider._(argument: id, from: this);

  @override
  String toString() => r'ticketProvider';
}

/// Import and cancel (#16, #17). Both refresh what they touched.

@ProviderFor(TicketActions)
final ticketActionsProvider = TicketActionsProvider._();

/// Import and cancel (#16, #17). Both refresh what they touched.
final class TicketActionsProvider
    extends $NotifierProvider<TicketActions, void> {
  /// Import and cancel (#16, #17). Both refresh what they touched.
  TicketActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketActionsHash();

  @$internal
  @override
  TicketActions create() => TicketActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$ticketActionsHash() => r'1f2c23312b2f264e1ae37e3ee8e32a7de16493e6';

/// Import and cancel (#16, #17). Both refresh what they touched.

abstract class _$TicketActions extends $Notifier<void> {
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
