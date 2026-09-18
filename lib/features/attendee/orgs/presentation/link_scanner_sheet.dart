import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/router/deep_link_parser.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';

/// Full-screen camera that reads a Thingstead link QR (an org or event page)
/// and returns its [DeepLinkTarget]. Anything else shows a hint and keeps
/// scanning. Returns null when dismissed.
Future<DeepLinkTarget?> showLinkScanner(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).push<DeepLinkTarget>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const _LinkScannerScreen(),
      ),
    );

class _LinkScannerScreen extends StatefulWidget {
  const _LinkScannerScreen();

  @override
  State<_LinkScannerScreen> createState() => _LinkScannerScreenState();
}

class _LinkScannerScreenState extends State<_LinkScannerScreen> {
  final _camera = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  final _parser = DeepLinkParser();
  String? _hint;
  bool _done = false;

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  void _onCode(String raw) {
    if (_done) return;
    final uri = Uri.tryParse(raw.trim());
    final target = uri == null ? null : _parser.parse(uri);
    if (target is OrgEventsTarget || target is EventDetailTarget) {
      _done = true;
      Navigator.of(context).pop(target);
      return;
    }
    setState(() {
      _hint = target == null
          ? "That's not a Thingstead link."
          : 'That link opens something else — scan an organization or event link.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _camera,
            onDetect: (capture) {
              final raw = capture.barcodes.firstOrNull?.rawValue;
              if (raw != null) _onCode(raw);
            },
            errorBuilder: (context, error) => _CameraProblem(
              denied: error.errorCode == MobileScannerErrorCode.permissionDenied,
            ),
          ),
          IgnorePointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold, width: 3),
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                ),
                const SizedBox(height: Spacing.x6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.x8),
                  child: Text(
                    _hint ?? 'Point the camera at a Thingstead link QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _hint == null ? Colors.white : AppColors.gold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraProblem extends StatelessWidget {
  const _CameraProblem({required this.denied});

  final bool denied;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF111827),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.x8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined, color: Colors.white54, size: 48),
              const SizedBox(height: Spacing.x4),
              Text(
                denied
                    ? 'Camera access is needed to scan a link. Allow it in Settings, '
                        'or type the organization code instead.'
                    : "The camera isn't available right now. Type the organization "
                        'code instead.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, height: 1.4),
              ),
              const SizedBox(height: Spacing.x4),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
