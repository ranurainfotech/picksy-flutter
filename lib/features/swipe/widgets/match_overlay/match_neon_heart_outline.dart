import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/app_match_overlay_tokens.dart';

/// Giant neon tube heart behind the MATCH title.
class MatchNeonHeartOutline extends StatefulWidget {
  const MatchNeonHeartOutline({
    super.key,
    this.size = const Size(220, 200),
  });

  final Size size;

  @override
  State<MatchNeonHeartOutline> createState() => _MatchNeonHeartOutlineState();
}

class _MatchNeonHeartOutlineState extends State<MatchNeonHeartOutline>
    with TickerProviderStateMixin {
  late final AnimationController _drawController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 1,
      upperBound: 1.06,
    );
    _drawController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.repeat(reverse: true, min: 1, max: 1.06);
      }
    });
  }

  @override
  void dispose() {
    _drawController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_drawController, _pulseController]),
      builder: (context, child) {
        final drawProgress = Curves.easeOutCubic.transform(_drawController.value);
        final scale = _drawController.isCompleted ? _pulseController.value : 1.0;

        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: widget.size,
            painter: _NeonHeartPainter(drawProgress: drawProgress),
          ),
        );
      },
    );
  }
}

class _NeonHeartPainter extends CustomPainter {
  _NeonHeartPainter({required this.drawProgress});

  final double drawProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _heartPath(size);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return;
    }

    final metric = metrics.first;
    final extract = metric.extractPath(0, metric.length * drawProgress);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.2, size.height * 0.2),
        Offset(size.width * 0.8, size.height * 0.9),
        [
          AppMatchOverlayTokens.heartGradientStart.withValues(alpha: 0.35),
          AppMatchOverlayTokens.heartGradientEnd.withValues(alpha: 0.35),
        ],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        const [
          AppMatchOverlayTokens.heartGradientStart,
          AppMatchOverlayTokens.heartGradientEnd,
        ],
      );

    canvas.drawPath(extract, glowPaint);
    canvas.drawPath(extract, strokePaint);
  }

  Path _heartPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, h * 0.92);
    path.cubicTo(w * 0.08, h * 0.62, w * 0.02, h * 0.28, w * 0.28, h * 0.16);
    path.cubicTo(w * 0.44, h * 0.08, w * 0.5, h * 0.22, w * 0.5, h * 0.28);
    path.cubicTo(w * 0.5, h * 0.22, w * 0.56, h * 0.08, w * 0.72, h * 0.16);
    path.cubicTo(w * 0.98, h * 0.28, w * 0.92, h * 0.62, w * 0.5, h * 0.92);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _NeonHeartPainter oldDelegate) {
    return oldDelegate.drawProgress != drawProgress;
  }
}
