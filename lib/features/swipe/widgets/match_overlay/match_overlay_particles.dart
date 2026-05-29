import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Lightweight floating confetti / sparkle layer.
class MatchOverlayParticles extends StatelessWidget {
  const MatchOverlayParticles({super.key});

  static final _rng = math.Random(42);

  static final _items = List<_ParticleSpec>.generate(22, (index) {
    final colors = [
      AppColors.neonPink,
      AppColors.electricPurple,
      AppColors.cyan,
      AppColors.neonYellow,
    ];
    return _ParticleSpec(
      leftFactor: _rng.nextDouble(),
      delayMs: 100 + _rng.nextInt(900),
      durationMs: 2200 + _rng.nextInt(1800),
      drift: (_rng.nextDouble() - 0.5) * 40,
      rotation: (_rng.nextDouble() - 0.5) * 0.8,
      size: 4 + _rng.nextDouble() * 8,
      color: colors[index % colors.length],
      isHeart: index % 5 == 0,
      isStreak: index % 4 == 1,
    );
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final (i, spec) in _items.indexed)
            Positioned(
              left: MediaQuery.sizeOf(context).width * spec.leftFactor,
              top: -20 + (i * 14.0),
              child: _ParticleWidget(spec: spec),
            ),
        ],
      ),
    );
  }
}

class _ParticleSpec {
  const _ParticleSpec({
    required this.leftFactor,
    required this.delayMs,
    required this.durationMs,
    required this.drift,
    required this.rotation,
    required this.size,
    required this.color,
    required this.isHeart,
    required this.isStreak,
  });

  final double leftFactor;
  final int delayMs;
  final int durationMs;
  final double drift;
  final double rotation;
  final double size;
  final Color color;
  final bool isHeart;
  final bool isStreak;
}

class _ParticleWidget extends StatelessWidget {
  const _ParticleWidget({required this.spec});

  final _ParticleSpec spec;

  @override
  Widget build(BuildContext context) {
    final child = spec.isHeart
        ? Icon(
            Icons.favorite_rounded,
            size: spec.size + 4,
            color: spec.color.withValues(alpha: 0.7),
          )
        : spec.isStreak
        ? Container(
            width: spec.size * 0.35,
            height: spec.size * 1.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: spec.color.withValues(alpha: 0.75),
            ),
          )
        : Container(
            width: spec.size,
            height: spec.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: spec.color.withValues(alpha: 0.85),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          );

    return child
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(duration: 300.ms, delay: spec.delayMs.ms)
        .then()
        .moveY(
          begin: 0,
          end: MediaQuery.sizeOf(context).height * 0.55,
          duration: spec.durationMs.ms,
          curve: Curves.easeInOut,
        )
        .rotate(begin: 0, end: spec.rotation)
        .fadeOut(delay: (spec.durationMs * 0.65).ms, duration: 500.ms);
  }
}
