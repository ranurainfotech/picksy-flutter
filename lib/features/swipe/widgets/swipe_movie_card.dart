import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../../movies/domain/entities/movie.dart';
import 'swipe_avatar_stack.dart';

class SwipeMovieCard extends StatelessWidget {
  const SwipeMovieCard({
    super.key,
    required this.movie,
    required this.likedUserIds,
  });

  final Movie movie;
  final List<String> likedUserIds;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (movie.posterUrl != null)
            CachedNetworkImage(
              imageUrl: movie.posterUrl!,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 120),
            )
          else
            const ColoredBox(color: Color(0xFF171B27)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE0000000)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontFamilyFallback: AppTypography.fallbackFonts,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${movie.releaseYear} • PG • 2h 20m • ⭐ ${movie.voteAverage.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontFamilyFallback: AppTypography.fallbackFonts,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xD9FFFFFF),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SwipeAvatarStack(
                      userIds: likedUserIds,
                      size: 24,
                      overlap: 6,
                      maxVisible: 5,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${likedUserIds.length} liked this',
                      style: AppTypography.bodyRegular.copyWith(
                        color: const Color(0xFFFF4DB8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
