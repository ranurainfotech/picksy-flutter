import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        gradient: AppSplashTokens.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientGlow(
            alignment: Alignment.topLeft,
            color: AppColors.electricPurple,
          ),
          const _AmbientGlow(
            alignment: Alignment.bottomRight,
            color: AppColors.neonPink,
          ),
          const _StarField(),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: AppSplashTokens.ambientGlowSize,
          height: AppSplashTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: AppSplashTokens.ambientGlowOpacity,
                ),
                blurRadius: AppSplashTokens.ambientGlowBlur,
                spreadRadius: AppSplashTokens.ambientGlowSpread,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _StarFieldPainter(), size: Size.infinite),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final star in AppSplashTokens.stars) {
      final paint = Paint()
        ..color = star.color.withValues(alpha: AppSplashTokens.starOpacity)
        ..strokeWidth = AppSplashTokens.starStrokeWidth
        ..strokeCap = StrokeCap.round;
      final center = Offset(size.width * star.x, size.height * star.y);
      final radius = star.radius;

      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
