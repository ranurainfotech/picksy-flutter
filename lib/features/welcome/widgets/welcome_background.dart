import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_welcome_tokens.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        gradient: AppWelcomeTokens.backgroundGradient,
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
          width: AppWelcomeTokens.ambientGlowSize,
          height: AppWelcomeTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: AppWelcomeTokens.ambientGlowOpacity,
                ),
                blurRadius: AppWelcomeTokens.ambientGlowBlur,
                spreadRadius: AppWelcomeTokens.ambientGlowSpread,
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
    for (final star in AppWelcomeTokens.stars) {
      final paint = Paint()
        ..color = star.color.withValues(alpha: AppWelcomeTokens.starOpacity)
        ..strokeWidth = AppWelcomeTokens.starStrokeWidth
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
