import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../models/match_overlay_data.dart';
import '../../theme/app_match_overlay_tokens.dart';
import 'match_matched_movie_card.dart';
import 'match_neon_heart_outline.dart';
import 'match_overlay_avatars.dart';
import 'match_overlay_particles.dart';

/// Full-screen cinematic match celebration overlay (not a route).
class MatchOverlayWidget extends StatefulWidget {
  const MatchOverlayWidget({
    super.key,
    required this.data,
    required this.onDismiss,
    this.onAddToWatchlist,
  });

  final MatchOverlayData data;
  final VoidCallback onDismiss;
  final VoidCallback? onAddToWatchlist;

  @override
  State<MatchOverlayWidget> createState() => _MatchOverlayWidgetState();
}

class _MatchOverlayWidgetState extends State<MatchOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMatchOverlayTokens.fadeOutDuration,
      value: 1,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_isDismissing || !mounted) {
      return;
    }
    _isDismissing = true;
    await _fadeController.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  Future<void> _onAddToWatchlist() async {
    widget.onAddToWatchlist?.call();
    await _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Backdrop(),
            const MatchOverlayParticles(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: _MatchOverlayBody(
                  data: widget.data,
                  onAddToWatchlist: _onAddToWatchlist,
                  onKeepSwiping: _dismiss,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppMatchOverlayTokens.blurSigma,
            sigmaY: AppMatchOverlayTokens.blurSigma,
          ),
          child: Container(
            color: AppMatchOverlayTokens.backdrop.withValues(alpha: 0),
          ),
        ),
      )
          .animate()
          .custom(
            duration: AppMatchOverlayTokens.backdropDuration,
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppMatchOverlayTokens.blurSigma,
                    sigmaY: AppMatchOverlayTokens.blurSigma,
                  ),
                  child: Container(
                    color: AppMatchOverlayTokens.backdrop.withValues(
                      alpha: AppMatchOverlayTokens.backdropMaxOpacity * value,
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _MatchOverlayBody extends StatelessWidget {
  const _MatchOverlayBody({
    required this.data,
    required this.onAddToWatchlist,
    required this.onKeepSwiping,
  });

  final MatchOverlayData data;
  final VoidCallback onAddToWatchlist;
  final VoidCallback onKeepSwiping;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 720;
        final titleTopSize = compact ? 34.0 : 42.0;
        final titleMatchSize = compact ? 46.0 : 56.0;
        final heartSize = compact ? const Size(150, 136) : const Size(190, 172);
        final avatarSize = compact ? 40.0 : 48.0;

        return Column(
          children: [
            Flexible(
              flex: compact ? 24 : 26,
              child: _TitleSection(
                titleTopSize: titleTopSize,
                titleMatchSize: titleMatchSize,
                heartSize: heartSize,
              ),
            ),
            Flexible(
              flex: compact ? 46 : 44,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: _MatchedMovieSection(data: data),
                ),
              ),
            ),
            Flexible(
              flex: compact ? 30 : 30,
              child: _BottomSection(
                data: data,
                avatarSize: avatarSize,
                compact: compact,
                onAddToWatchlist: onAddToWatchlist,
                onKeepSwiping: onKeepSwiping,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({
    required this.titleTopSize,
    required this.titleMatchSize,
    required this.heartSize,
  });

  final double titleTopSize;
  final double titleMatchSize;
  final Size heartSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: MatchNeonHeartOutline(size: heartSize)
              .animate()
              .fadeIn(delay: 150.ms, duration: 200.ms),
        ),
        Padding(
          padding: EdgeInsets.only(top: heartSize.height * 0.14),
          child: _MatchHeadline(
            titleTopSize: titleTopSize,
            titleMatchSize: titleMatchSize,
          )
              .animate()
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                delay: 250.ms,
                duration: AppMatchOverlayTokens.titleDuration,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: 250.ms, duration: 200.ms)
              .slideY(begin: 0.12, end: 0, delay: 250.ms, duration: 300.ms),
        ),
      ],
    );
  }
}

class _MatchHeadline extends StatelessWidget {
  const _MatchHeadline({
    required this.titleTopSize,
    required this.titleMatchSize,
  });

  final double titleTopSize;
  final double titleMatchSize;

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppMatchOverlayTokens.matchGradientTop,
        AppMatchOverlayTokens.matchGradientBottom,
      ],
    );

    final headline = AppMatchOverlayTokens.matchHeadlineStyle(fontSize: titleTopSize);
    final matchLine = AppMatchOverlayTokens.matchHeadlineStyle(fontSize: titleMatchSize);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(AppMatchOverlayTokens.matchTitleRotateZ)
        ..setEntry(0, 1, AppMatchOverlayTokens.matchTitleSkewX),
      child: ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "IT'S A",
              textAlign: TextAlign.center,
              style: headline.copyWith(
                shadows: [
                  Shadow(
                    color: AppColors.neonPink.withValues(alpha: 0.55),
                    blurRadius: 28,
                  ),
                ],
              ),
            ),
            Text(
              'MATCH!',
              textAlign: TextAlign.center,
              style: matchLine.copyWith(
                height: 0.82,
                shadows: [
                  Shadow(
                    color: AppColors.neonPink.withValues(alpha: 0.85),
                    blurRadius: 36,
                  ),
                  Shadow(
                    color: AppColors.neonPink.withValues(alpha: 0.4),
                    blurRadius: 56,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchedMovieSection extends StatelessWidget {
  const _MatchedMovieSection({required this.data});

  final MatchOverlayData data;

  @override
  Widget build(BuildContext context) {
    return MatchMatchedMovieCard(data: data)
        .animate()
        .fadeIn(delay: 500.ms, duration: 220.ms)
        .slideY(
          begin: 120,
          end: 0,
          delay: 500.ms,
          duration: AppMatchOverlayTokens.cardsDuration,
          curve: Curves.easeOutBack,
        )
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          delay: 500.ms,
          duration: AppMatchOverlayTokens.cardsDuration,
          curve: Curves.easeOutBack,
        );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.data,
    required this.avatarSize,
    required this.compact,
    required this.onAddToWatchlist,
    required this.onKeepSwiping,
  });

  final MatchOverlayData data;
  final double avatarSize;
  final bool compact;
  final VoidCallback onAddToWatchlist;
  final VoidCallback onKeepSwiping;

  @override
  Widget build(BuildContext context) {
    final primarySize = compact ? 17.0 : 18.0;
    final lineSize = compact ? 18.0 : 20.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MatchOverlayAvatars(
          userIds: data.likedUserIds,
          size: avatarSize,
          overlap: avatarSize * 0.34,
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 280.ms),
        SizedBox(height: compact ? 6 : 10),
        Text(
          data.primaryLine,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.heading3.copyWith(
            fontSize: lineSize,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.15,
          ),
        )
            .animate()
            .fadeIn(delay: 1000.ms, duration: 350.ms),
        SizedBox(height: compact ? 8 : 10),
        _PrimaryButton(
          onPressed: onAddToWatchlist,
          height: compact ? 50 : 54,
          fontSize: primarySize,
        )
            .animate()
            .fadeIn(delay: 1200.ms, duration: 300.ms)
            .slideY(begin: 0.12, end: 0, delay: 1200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        TextButton(
          onPressed: onKeepSwiping,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: compact ? 4 : 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Keep Swiping',
            style: AppTypography.bodyRegular.copyWith(
              fontSize: compact ? 14 : 15,
              color: Colors.white.withValues(alpha: 0.55),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 1350.ms, duration: 280.ms),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.onPressed,
    this.height = 54,
    this.fontSize = 18,
  });

  final VoidCallback onPressed;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4DB8), AppColors.softPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Add to Watchlist',
                style: AppTypography.button.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

