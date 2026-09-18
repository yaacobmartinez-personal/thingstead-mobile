import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/illustrations.dart';
import '../../../core/theme/motion.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/ui/pill_button.dart';
import '../../../core/ui/round_icon_button.dart';
import '../../shell/application/app_mode_controller.dart';
import '../application/onboarding_controller.dart';

class _Page {
  const _Page(this.asset, this.title, this.body);
  final String asset;
  final String title;
  final String body;
}

/// Three pages, shown once: full-bleed illustration with a parallax, a
/// sheet with the copy, dots, Skip, and Next / Get started.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const pages = [
    _Page(
      Illustrations.onboarding1,
      'Join events near you',
      'Open an organization\'s link or code and see what\'s coming up. Register in a tap.',
    ),
    _Page(
      Illustrations.onboarding2,
      'Your ticket lives here',
      'Every place you take shows up as a ticket with its QR code, ready at the door.',
    ),
    _Page(
      Illustrations.onboarding3,
      'Run the door from your phone',
      'Organizers scan tickets, manage the list, and keep checking people in even offline.',
    ),
  ];

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _page = _controller.page ?? 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    ref.read(onboardingSeenProvider.notifier).set(true);
    context.go(AppMode.attendee.home);
  }

  void _next() {
    final index = _page.round();
    if (index >= OnboardingScreen.pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(duration: Motion.slow, curve: Motion.move);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = MediaQuery.sizeOf(context);
    final top = MediaQuery.paddingOf(context).top;
    final pages = OnboardingScreen.pages;
    final index = _page.round();
    final last = index == pages.length - 1;
    final heroHeight = size.height * 0.58;

    return Scaffold(
      backgroundColor: p.sage,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Illustrations, each drifting at 0.3× the page scroll.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight + 40,
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              itemBuilder: (context, i) {
                final delta = (i - _page) * size.width * 0.3;
                return Transform.translate(
                  offset: Offset(delta, 0),
                  child: Image.asset(
                    pages[i].asset,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                );
              },
            ),
          ),
          // Sheet with copy.
          Positioned(
            left: 0,
            right: 0,
            top: heroHeight - 24,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: p.sage,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
              ),
              padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x8, Spacing.gutter, Spacing.x4),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Motion.base,
                        switchInCurve: Motion.enter,
                        child: Column(
                          key: ValueKey(index),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pages[index].title, style: AppType.display.copyWith(color: p.ink)),
                            const SizedBox(height: Spacing.x3),
                            Text(pages[index].body, style: AppType.body.copyWith(color: p.muted, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < pages.length; i++)
                          AnimatedContainer(
                            duration: Motion.base,
                            curve: Motion.move,
                            margin: const EdgeInsets.only(right: 6),
                            width: i == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == index ? p.limeDeep : p.sageDeep,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.x5),
                    PillButton(
                      label: last ? 'Get started' : 'Next',
                      onPressed: _next,
                      icon: last ? null : Icons.arrow_forward,
                      trailingIcon: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: top + 8,
            right: Spacing.gutter,
            child: AnimatedOpacity(
              opacity: last ? 0 : 1,
              duration: Motion.base,
              child: IgnorePointer(
                ignoring: last,
                child: Row(
                  children: [
                    Material(
                      color: p.surface,
                      shape: const StadiumBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _finish,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                          child: Row(
                            children: [
                              Text('Skip', style: AppType.label.copyWith(color: p.ink)),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right, size: 18, color: p.ink),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (index > 0)
            Positioned(
              top: top + 8,
              left: Spacing.gutter,
              child: RoundIconButton(
                icon: Icons.arrow_back,
                onPressed: () => _controller.previousPage(duration: Motion.slow, curve: Motion.move),
              ),
            ),
        ],
      ),
    );
  }
}
