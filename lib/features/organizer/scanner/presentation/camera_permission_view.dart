import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';

/// Shown in place of the camera when access was denied or the camera failed.
/// Copy from the Expo ScannerScreen permission state.
class CameraPermissionView extends StatelessWidget {
  const CameraPermissionView({
    super.key,
    required this.denied,
    required this.onRetry,
    required this.onManual,
    required this.onBack,
  });

  final bool denied;
  final VoidCallback onRetry;
  final VoidCallback onManual;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: const EdgeInsets.all(Spacing.x6),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.no_photography_outlined, color: AppColors.gold, size: 48),
            const SizedBox(height: Spacing.x4),
            Text(
              denied ? 'Camera access needed' : 'Camera unavailable',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onNavy,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: Spacing.x2),
            Text(
              denied
                  ? 'Thingstead uses the camera only to read attendee QR codes '
                      'for check-in. Allow it in Settings, then try again.'
                  : 'The camera could not be started. You can still enter '
                      'codes by hand.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.onNavy, height: 1.4),
            ),
            const SizedBox(height: Spacing.x6),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.navyDark,
              ),
              child: const Text('Try again'),
            ),
            const SizedBox(height: Spacing.x3),
            OutlinedButton(
              onPressed: onManual,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onNavy,
                side: const BorderSide(color: AppColors.onNavy),
              ),
              child: const Text('Enter a code instead'),
            ),
            TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(foregroundColor: AppColors.onNavy),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
