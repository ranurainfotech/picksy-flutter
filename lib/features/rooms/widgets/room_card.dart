import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../models/room_preview.dart';
import '../theme/app_rooms_tokens.dart';
import 'member_avatar_stack.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room, required this.onTap});

  final RoomPreview room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: AppRoomsTokens.roomCardHeight,
        padding: const EdgeInsets.all(AppSpacing.small),
        decoration: BoxDecoration(
          gradient: AppRoomsTokens.cardGradient,
          borderRadius: BorderRadius.circular(AppRoomsTokens.roomCardRadius),
          border: Border.all(
            color: AppColors.primaryBorder.withValues(
              alpha: AppRoomsTokens.roomCardBorderOpacity,
            ),
          ),
          boxShadow: AppRoomsTokens.roomCardShadow,
        ),
        child: Stack(
          children: [
            Positioned(
              right: AppRoomsTokens.cardGlowRight,
              top: AppRoomsTokens.cardGlowTop,
              child: _CardGlow(color: room.posterColors.first),
            ),
            Row(
              children: [
                _RoomPoster(room: room),
                const SizedBox(width: AppSpacing.regular),
                Expanded(child: _RoomDetails(room: room)),
                const Icon(
                  AppIcons.chevronRight,
                  color: AppColors.neonPink,
                  size: AppRoomsTokens.chevronSize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomPoster extends StatelessWidget {
  const _RoomPoster({required this.room});

  final RoomPreview room;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRoomsTokens.roomPosterRadius),
      child: Container(
        width: AppRoomsTokens.roomPosterSize,
        height: AppRoomsTokens.roomPosterSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: room.posterColors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _PosterTexturePainter(room.posterColors)),
            Positioned(
              right: AppRoomsTokens.roomPosterAmbientIconOffset,
              bottom: AppRoomsTokens.roomPosterAmbientIconOffset,
              child: Icon(
                room.posterIcon,
                color: AppColors.primaryText.withValues(alpha: 0.14),
                size: AppRoomsTokens.roomPosterAmbientIconSize,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryText.withValues(alpha: 0.08),
                    Colors.transparent,
                    AppColors.primaryBackground.withValues(alpha: 0.28),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.small,
              bottom: AppSpacing.small,
              child: Icon(
                room.posterIcon,
                color: AppColors.primaryText.withValues(alpha: 0.92),
                size: AppRoomsTokens.roomPosterIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardGlow extends StatelessWidget {
  const _CardGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: AppRoomsTokens.ambientGlowSize,
        height: AppRoomsTokens.ambientGlowSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(
                alpha: AppRoomsTokens.roomCardBlurOpacity,
              ),
              blurRadius: AppRoomsTokens.ambientGlowBlur,
              spreadRadius: AppRoomsTokens.cardGlowSpread,
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterTexturePainter extends CustomPainter {
  const _PosterTexturePainter(this.colors);

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryText.withValues(alpha: 0.16),
          colors.length > 1
              ? colors[1].withValues(alpha: 0.26)
              : AppColors.neonPink.withValues(alpha: 0.22),
        ],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawLine(
        Offset(size.width * 0.06, size.height * 0.18),
        Offset(size.width * 0.56, size.height * 0.02),
        beamPaint,
      )
      ..drawLine(
        Offset(size.width * 0.18, size.height * 0.92),
        Offset(size.width * 0.92, size.height * 0.42),
        beamPaint,
      );

    final sparklePaint = Paint()
      ..color = AppColors.primaryText.withValues(alpha: 0.22);

    for (final offset in [
      Offset(size.width * 0.20, size.height * 0.22),
      Offset(size.width * 0.70, size.height * 0.24),
      Offset(size.width * 0.76, size.height * 0.72),
    ]) {
      canvas.drawCircle(offset, AppRoomsTokens.posterSparkleSize, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PosterTexturePainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}

class _RoomDetails extends StatelessWidget {
  const _RoomDetails({required this.room});

  final RoomPreview room;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${room.title} ${room.emoji}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.tiny),
        Text(
          room.category,
          style: AppTypography.caption.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.regular),
        Row(
          children: [
            MemberAvatarStack(assetPaths: room.avatarAssetPaths, totalCount: room.membersCount),
            const Spacer(),
            SizedBox(
              width: AppRoomsTokens.memberCountWidth,
              child: Text(
                '${room.membersCount} members',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.tertiaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
