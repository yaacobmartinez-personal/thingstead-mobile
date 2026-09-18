import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../events/application/events_controller.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/scanner_controller.dart';
import '../domain/scan_source.dart';
import 'camera_permission_view.dart';
import 'manual_entry_sheet.dart';
import 'scan_result_card.dart';

/// Full-screen QR check-in. Port of the Expo ScannerScreen: gold reticle,
/// event label, in-flight lock, outcome card, "Scan next", plus torch and
/// manual entry. Pinned to [eventSlug] when given, so a ticket for another
/// event reads "wrong event".
///
/// [source] replaces the camera (tests, deep links); [initialCode] submits
/// once on open (the `app.thingstead.pro/checkin?c=` link).
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({
    super.key,
    this.eventSlug,
    this.initialCode,
    this.source,
  });

  final String? eventSlug;
  final String? initialCode;
  final ScanSource? source;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController? _camera;
  StreamSubscription<String>? _sourceSub;
  int _cameraGeneration = 0;

  @override
  void initState() {
    super.initState();
    final source = widget.source;
    if (source != null) {
      _sourceSub = source.codes.listen(_onCode);
      source.start();
    } else {
      _camera = _newCamera();
    }
    final code = widget.initialCode;
    if (code != null && code.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onCode(code));
    }
  }

  MobileScannerController _newCamera() => MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: const [BarcodeFormat.qrCode],
      );

  @override
  void dispose() {
    _sourceSub?.cancel();
    widget.source?.stop();
    _camera?.dispose();
    super.dispose();
  }

  /// Read (not watched) for callbacks; build() watches it separately so the
  /// screen follows an org switch.
  String? get _org => ref.read(selectedOrgProvider)?.slug;

  void _onCode(String code) {
    final org = _org;
    if (org == null) return;
    final zone = _eventZone();
    ref
        .read(scannerControllerProvider(org, widget.eventSlug).notifier)
        .submit(code, zone: zone);
  }

  String? _eventZone() {
    final org = _org;
    final slug = widget.eventSlug;
    if (org == null || slug == null) return null;
    final events = ref.read(orgEventsProvider(org)).value?.events;
    return events?.where((e) => e.slug == slug).firstOrNull?.timezone;
  }

  String _eventTitle() {
    final org = _org;
    final slug = widget.eventSlug;
    if (org == null) return '';
    if (slug == null) return 'Any event';
    final events = ref.watch(orgEventsProvider(org)).value?.events;
    return events?.where((e) => e.slug == slug).firstOrNull?.title ?? slug;
  }

  Future<void> _manual() async {
    final code = await showManualEntrySheet(context);
    if (code != null && code.isNotEmpty) _onCode(code);
  }

  void _retryCamera() {
    _camera?.dispose();
    setState(() {
      _camera = _newCamera();
      _cameraGeneration++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final org = ref.watch(selectedOrgProvider)?.slug;
    if (org == null) return const Scaffold(body: SizedBox.shrink());
    final state = ref.watch(scannerControllerProvider(org, widget.eventSlug));
    final notifier = ref.read(scannerControllerProvider(org, widget.eventSlug).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_camera != null)
            MobileScanner(
              key: ValueKey(_cameraGeneration),
              controller: _camera,
              onDetect: (capture) {
                final raw = capture.barcodes.firstOrNull?.rawValue;
                if (raw != null && state.accepting) _onCode(raw);
              },
              errorBuilder: (context, error) => CameraPermissionView(
                denied: error.errorCode == MobileScannerErrorCode.permissionDenied,
                onRetry: _retryCamera,
                onManual: _manual,
                onBack: () => context.pop(),
              ),
            )
          else
            const ColoredBox(color: Color(0xFF111827)),

          // Framing guide + event label.
          IgnorePointer(
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Spacing.x3),
                    child: _Pill(child: Text(_eventTitle(), maxLines: 1)),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold, width: 3),
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                ),
                const Spacer(),
                if (state.accepting)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: _Pill(child: Text("Point at an attendee's QR code")),
                  ),
                if (state.phase == ScannerPhase.busy)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: _Pill(child: Text('Checking…')),
                  ),
              ],
            ),
          ),

          // Top-left back, top-right torch + manual + counter.
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Done',
                ),
                const Spacer(),
                if (state.scanned > 0)
                  _Pill(child: Text('${state.scanned} in')),
                IconButton(
                  onPressed: _manual,
                  icon: const Icon(Icons.keyboard_alt_outlined, color: Colors.white),
                  tooltip: 'Enter a code',
                ),
                if (_camera != null)
                  IconButton(
                    onPressed: () => _camera!.toggleTorch(),
                    icon: const Icon(Icons.flashlight_on_outlined, color: Colors.white),
                    tooltip: 'Torch',
                  ),
              ],
            ),
          ),

          // Result card.
          if (state.phase == ScannerPhase.result && state.feedback != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.x4),
                  child: ScanResultCard(
                    feedback: state.feedback!,
                    onNext: notifier.scanNext,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.x4, vertical: Spacing.x2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        child: child,
      ),
    );
  }
}
