import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class SplashHeroArt extends StatelessWidget {
  const SplashHeroArt({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSplashTokens.heroHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _PositionedAssetSticker(spec: AppSplashTokens.film),
          _PositionedAssetSticker(spec: AppSplashTokens.popcorn),
          _PositionedAssetSticker(spec: AppSplashTokens.console),
        ],
      ),
    );
  }
}

class _PositionedAssetSticker extends StatelessWidget {
  const _PositionedAssetSticker({required this.spec});

  final SplashAssetSpec spec;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: spec.left,
      top: spec.top,
      right: spec.right,
      bottom: spec.bottom,
      child: _LoopingAssetSticker(spec: spec),
    );
  }
}

class _LoopingAssetSticker extends StatefulWidget {
  const _LoopingAssetSticker({required this.spec});

  final SplashAssetSpec spec;

  @override
  State<_LoopingAssetSticker> createState() => _LoopingAssetStickerState();
}

class _LoopingAssetStickerState extends State<_LoopingAssetSticker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.spec.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final wave = math.sin(
          (_controller.value * math.pi * 2) + widget.spec.phase,
        );

        return Transform.translate(
          offset: Offset(0, wave * AppSplashTokens.assetFloatDistance),
          child: Transform.rotate(
            angle:
                widget.spec.angle + (wave * AppSplashTokens.assetRotationDrift),
            child: Transform.scale(
              scale: 1 + (wave * AppSplashTokens.assetScaleDrift),
              child: child,
            ),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.xlBorder,
          boxShadow: AppShadows.elevated,
        ),
        child: Image.asset(
          widget.spec.assetPath,
          width: widget.spec.width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
