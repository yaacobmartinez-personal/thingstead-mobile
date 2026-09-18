import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import 'round_icon_button.dart';

/// The reference's screen shape: an illustration bleeding to the top with a
/// scrim, floating round buttons, a title over the image, and a sheet with
/// a rounded top that overlaps the image and holds the content.
///
/// The image parallaxes at 0.4× as the sheet scrolls over it; once the
/// title would be covered, a compact bar with the title fades in.
class HeroScaffold extends StatefulWidget {
  const HeroScaffold({
    super.key,
    required this.image,
    required this.children,
    this.title,
    this.subtitle,
    this.eyebrow,
    this.leading,
    this.actions = const [],
    this.heroFraction = 0.42,
    this.onRefresh,
    this.controller,
    this.heroOverlay,
    this.bottom,
    this.imageAlignment = Alignment.center,
    this.scrollKey,
  });

  final ImageProvider image;
  final List<Widget> children;

  /// Large text over the image, bottom-left.
  final String? title;
  final String? subtitle;

  /// Small line above the title, e.g. "By Acme Meetups".
  final String? eyebrow;

  /// Top-left floating button; defaults to a back button when the route
  /// can pop.
  final Widget? leading;
  final List<Widget> actions;

  /// Share of the screen height the image takes before content covers it.
  final double heroFraction;
  final Future<void> Function()? onRefresh;
  final ScrollController? controller;

  /// Extra widgets over the image (e.g. a status chip).
  final Widget? heroOverlay;

  /// Pinned below the sheet (an action bar).
  final Widget? bottom;
  final Alignment imageAlignment;
  final Key? scrollKey;

  @override
  State<HeroScaffold> createState() => _HeroScaffoldState();
}

class _HeroScaffoldState extends State<HeroScaffold> {
  late final ScrollController _controller =
      widget.controller ?? ScrollController();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() => setState(() => _offset = _controller.offset);

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = MediaQuery.sizeOf(context);
    final top = MediaQuery.paddingOf(context).top;
    final heroHeight = size.height * widget.heroFraction;
    const overlap = 24.0;
    final collapseAt = heroHeight - top - 80;
    final collapsed = (_offset / collapseAt).clamp(0.0, 1.0);
    final canPop = Navigator.of(context).canPop();
    final leading =
        widget.leading ??
        (canPop
            ? RoundIconButton(
                icon: Icons.arrow_back,
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null);

    final scroll = CustomScrollView(
      key: widget.scrollKey,
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: heroHeight - overlap)),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            decoration: BoxDecoration(
              color: p.sage,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Radii.sheet),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              Spacing.gutter,
              Spacing.x6,
              Spacing.gutter,
              Spacing.gutter + (widget.bottom == null ? 0 : 128),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: p.sage,
      body: Stack(
        children: [
          // Image with parallax and scrim.
          Positioned(
            top: -_offset * 0.4,
            left: 0,
            right: 0,
            height: heroHeight + 40,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(
                  image: widget.image,
                  fit: BoxFit.cover,
                  alignment: widget.imageAlignment,
                ),
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
          // Title block over the image.
          if (widget.title != null || widget.eyebrow != null)
            Positioned(
              left: Spacing.gutter,
              right: Spacing.gutter,
              top: heroHeight - overlap - 24 - _offset,
              child: FractionalTranslation(
                translation: const Offset(0, -1),
                child: Opacity(
                  opacity: 1 - collapsed,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.heroOverlay != null) ...[
                        widget.heroOverlay!,
                        const SizedBox(height: Spacing.x2),
                      ],
                      if (widget.eyebrow != null)
                        Text(
                          widget.eyebrow!,
                          style: AppType.small.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.display.copyWith(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.subtitle!,
                            style: AppType.body.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (widget.onRefresh != null)
            RefreshIndicator(
              onRefresh: widget.onRefresh!,
              edgeOffset: top + 8,
              child: scroll,
            )
          else
            scroll,
          // Compact bar that appears once the hero is scrolled away.
          if (collapsed > 0)
            IgnorePointer(
              ignoring: collapsed < 0.5,
              child: Opacity(
                opacity: collapsed,
                child: Container(
                  height: top + 56,
                  padding: EdgeInsets.only(top: top),
                  color: p.sage,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 72, right: 72),
                    child: Text(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.heading.copyWith(color: p.ink),
                    ),
                  ),
                ),
              ),
            ),
          // Floating buttons stay on top of everything.
          Positioned(
            top: top + 8,
            left: Spacing.gutter,
            right: Spacing.gutter,
            child: Row(
              children: [
                ?leading,
                const Spacer(),
                for (final (i, a) in widget.actions.indexed) ...[
                  if (i > 0) const SizedBox(width: Spacing.x2),
                  a,
                ],
              ],
            ),
          ),
          if (widget.bottom != null)
            Positioned(left: 0, right: 0, bottom: 0, child: widget.bottom!),
        ],
      ),
    );
  }
}

/// A pinned action bar for [HeroScaffold.bottom]: sage fade above, then the
/// child with safe-area padding.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.sage.withValues(alpha: 0), p.sage, p.sage],
          stops: const [0, 0.35, 1],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.gutter,
            Spacing.x6,
            Spacing.gutter,
            Spacing.x3,
          ),
          child: child,
        ),
      ),
    );
  }
}
