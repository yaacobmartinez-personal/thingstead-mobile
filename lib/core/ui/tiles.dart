import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// The reference's category row item: an icon on a white rounded square
/// with a caption below.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: selected ? p.lime : p.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Icon(icon, size: 26, color: color ?? (selected ? p.onLime : p.moss)),
            ),
          ),
        ),
        const SizedBox(height: Spacing.x2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppType.captionQuiet.copyWith(color: p.muted, fontSize: 11),
        ),
      ],
    );
  }
}

/// "DEC / 24 / Monday / 08:00 pm – End" with an optional trailing button.
class DateTile extends StatelessWidget {
  const DateTile({
    super.key,
    required this.month,
    required this.day,
    required this.weekday,
    required this.time,
    this.trailing,
    this.compact = false,
  });

  final String month;
  final String day;
  final String weekday;
  final String time;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: EdgeInsets.all(compact ? Spacing.x2 : Spacing.x3),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        boxShadow: compact
            ? null
            : [BoxShadow(color: p.shadow, blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 48 : 56,
            padding: const EdgeInsets.symmetric(vertical: Spacing.x2),
            decoration: BoxDecoration(
              color: p.surfaceTint,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Column(
              children: [
                Text(
                  month.toUpperCase(),
                  style: AppType.caption.copyWith(color: p.muted, fontSize: 10),
                ),
                Text(
                  day,
                  style: (compact ? AppType.numeralSmall : AppType.numeral)
                      .copyWith(color: p.ink, height: 1.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weekday, style: AppType.bodyStrong.copyWith(color: p.ink)),
                Text(time, style: AppType.small.copyWith(color: p.muted)),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A circle with initials, colored from the name so the same person always
/// gets the same tone.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.size = 36, this.border = false});

  final String name;
  final double size;
  final bool border;

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    // Always pale so the ink initials read in both themes.
    const tones = [
      Color(0xFFC8DC96),
      Color(0xFFB5D3A0),
      Color(0xFFF2DFA6),
      Color(0xFFC9E3D5),
      Color(0xFFF3C9C2),
    ];
    final h = name.codeUnits.fold<int>(0, (a, c) => (a * 31 + c) & 0x7fffffff);
    final bg = tones[h % tones.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: border ? Border.all(color: p.surface, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials(name),
        style: AppType.label.copyWith(color: p.onLime, fontSize: size * 0.36),
      ),
    );
  }
}

/// Overlapping avatars with a "+N" pill. With no names (public pages know
/// only counts) it draws [placeholders] generic heads instead.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    this.names = const [],
    this.placeholders = 0,
    this.extra = 0,
    this.size = 36,
  });

  final List<String> names;
  final int placeholders;
  final int extra;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final shown = names.take(3).toList();
    final heads = shown.isEmpty ? placeholders.clamp(0, 3) : shown.length;
    final overlap = size * 0.3;
    const tones = [Color(0xFFC8DC96), Color(0xFFD7E4BE), Color(0xFFF2DFA6)];
    return SizedBox(
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < heads; i++)
            Positioned(
              left: i * (size - overlap),
              child: shown.isEmpty
                  ? Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: tones[i % tones.length],
                        shape: BoxShape.circle,
                        border: Border.all(color: p.surface, width: 2),
                      ),
                      child: Icon(Icons.person, size: size * 0.55, color: p.onLime),
                    )
                  : InitialsAvatar(name: shown[i], size: size, border: true),
            ),
          if (extra > 0)
            Positioned(
              left: heads * (size - overlap),
              child: Container(
                height: size,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: p.lime,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: p.surface, width: 2),
                ),
                alignment: Alignment.center,
                child: Text('+$extra', style: AppType.label.copyWith(color: p.onLime, fontSize: 13)),
              ),
            ),
          // Reserve width so the stack lays out inside rows.
          SizedBox(width: (heads + (extra > 0 ? 1 : 0)) * (size - overlap) + overlap + 24),
        ],
      ),
    );
  }
}

/// "MEMBERS (3)" — the tracked uppercase section label.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(text.toUpperCase(), style: AppType.caption.copyWith(color: p.faint)),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
