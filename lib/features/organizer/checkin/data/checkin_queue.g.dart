// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_queue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkinQueue)
final checkinQueueProvider = CheckinQueueProvider._();

final class CheckinQueueProvider
    extends $FunctionalProvider<CheckinQueue, CheckinQueue, CheckinQueue>
    with $Provider<CheckinQueue> {
  CheckinQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkinQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkinQueueHash();

  @$internal
  @override
  $ProviderElement<CheckinQueue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckinQueue create(Ref ref) {
    return checkinQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckinQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckinQueue>(value),
    );
  }
}

String _$checkinQueueHash() => r'b5718d4ad00ba7c3cf5c23a34410f8fe79aaadaf';

@ProviderFor(attentionOps)
final attentionOpsProvider = AttentionOpsProvider._();

final class AttentionOpsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PendingOp>>,
          List<PendingOp>,
          Stream<List<PendingOp>>
        >
    with $FutureModifier<List<PendingOp>>, $StreamProvider<List<PendingOp>> {
  AttentionOpsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attentionOpsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attentionOpsHash();

  @$internal
  @override
  $StreamProviderElement<List<PendingOp>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PendingOp>> create(Ref ref) {
    return attentionOps(ref);
  }
}

String _$attentionOpsHash() => r'82af9f6bf5f791c9a1fd4e87aab3f6a6a3d6835c';
