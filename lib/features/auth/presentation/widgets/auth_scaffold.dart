import 'package:flutter/material.dart';

import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/round_icon_button.dart';
import '../../../../core/ui/stagger.dart';

/// The auth layout: the garden-gate illustration bleeding to the top, the
/// wordmark and title over its scrim, and a sheet with the form. Shared by
/// every auth screen; [compact] shrinks the hero for the secondary screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.showBack = false,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBack;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = MediaQuery.sizeOf(context);
    final top = MediaQuery.paddingOf(context).top;
    final heroHeight = size.height * (compact ? 0.30 : 0.40);
    return Scaffold(
      backgroundColor: p.sage,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight + 40,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(Illustrations.auth, fit: BoxFit.cover, alignment: Alignment.bottomCenter),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.2, 0.55, 1],
                      colors: p.scrim,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: heroHeight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Spacing.gutter, 0, Spacing.gutter, Spacing.x10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Wordmark(),
                        const SizedBox(height: Spacing.x3),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.display.copyWith(color: Colors.white, fontSize: 30),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.body.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    constraints: BoxConstraints(minHeight: size.height - heroHeight + 24),
                    decoration: BoxDecoration(
                      color: p.sage,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.gutter,
                      Spacing.x6,
                      Spacing.gutter,
                      Spacing.x8,
                    ),
                    child: StaggeredColumn(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Spacing.gutter),
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: BorderRadius.circular(Radii.card),
                          ),
                          child: child,
                        ),
                        if (footer != null) ...[const SizedBox(height: Spacing.x5), footer!],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showBack)
            Positioned(
              top: top + 8,
              left: Spacing.gutter,
              child: RoundIconButton(
                icon: Icons.arrow_back,
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: p.lime, borderRadius: BorderRadius.circular(Radii.sm)),
          child: Text('T', style: AppType.heading.copyWith(color: p.onLime, fontSize: 20)),
        ),
        const SizedBox(width: Spacing.x2),
        Text('Thingstead', style: AppType.heading.copyWith(color: Colors.white)),
      ],
    );
  }
}

/// Inline error inside an auth card.
class AuthError extends StatelessWidget {
  const AuthError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Spacing.x4),
      padding: const EdgeInsets.all(Spacing.x3),
      decoration: BoxDecoration(color: p.dangerBg, borderRadius: BorderRadius.circular(Radii.sm)),
      child: Text(message, style: AppType.small.copyWith(color: p.danger, fontWeight: FontWeight.w600)),
    );
  }
}

/// Inline success/info inside an auth card.
class AuthNotice extends StatelessWidget {
  const AuthNotice(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Spacing.x4),
      padding: const EdgeInsets.all(Spacing.x3),
      decoration: BoxDecoration(color: p.successBg, borderRadius: BorderRadius.circular(Radii.sm)),
      child: Text(message, style: AppType.small.copyWith(color: p.success, fontWeight: FontWeight.w600)),
    );
  }
}
