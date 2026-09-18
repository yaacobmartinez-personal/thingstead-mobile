import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/spacing.dart';

/// A ticket-shaped card: rounded corners, a notch on each side at the
/// perforation, and a dashed line across it. [stub] sits below the line.
class TicketCard extends StatefulWidget {
  const TicketCard({
    super.key,
    required this.body,
    this.stub,
    this.color,
    this.notchRadius = 12,
    this.onTap,
  });

  final Widget body;
  final Widget? stub;
  final Color? color;
  final double notchRadius;
  final VoidCallback? onTap;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  final _bodyKey = GlobalKey();
  double? _perforationY;

  static const _gap = Spacing.x4;

  void _measure() {
    final box = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final y = box.size.height + _gap / 2;
    if (y != _perforationY && mounted) setState(() => _perforationY = y);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    if (widget.stub != null) WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    return CustomPaint(
      painter: _TicketPainter(
        fill: widget.color ?? p.surface,
        dash: p.sageDeep,
        notchRadius: widget.notchRadius,
        perforationY: widget.stub == null ? null : _perforationY,
        shadow: p.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(Radii.card),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                key: _bodyKey,
                padding: const EdgeInsets.all(Spacing.gutter),
                child: widget.body,
              ),
              if (widget.stub != null) ...[
                const SizedBox(height: _gap),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.gutter, 0, Spacing.gutter, Spacing.gutter),
                  child: widget.stub,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  _TicketPainter({
    required this.fill,
    required this.dash,
    required this.notchRadius,
    required this.perforationY,
    required this.shadow,
  });

  final Color fill;
  final Color dash;
  final double notchRadius;
  final double? perforationY;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(Radii.card));
    var path = Path()..addRRect(rrect);
    final y = perforationY;
    final cut = y != null && y < size.height;
    if (cut) {
      final notches = Path()
        ..addOval(Rect.fromCircle(center: Offset(0, y), radius: notchRadius))
        ..addOval(Rect.fromCircle(center: Offset(size.width, y), radius: notchRadius));
      path = Path.combine(PathOperation.difference, path, notches);
    }
    canvas.drawShadow(path.shift(const Offset(0, 4)), shadow, 10, true);
    canvas.drawPath(path, Paint()..color = fill);
    if (cut) {
      final paint = Paint()
        ..color = dash
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      var x = notchRadius + 10.0;
      while (x < size.width - notchRadius - 10) {
        canvas.drawLine(Offset(x, y), Offset(x + 8, y), paint);
        x += 16;
      }
    }
  }

  @override
  bool shouldRepaint(_TicketPainter old) =>
      old.fill != fill || old.perforationY != perforationY || old.dash != dash;
}
