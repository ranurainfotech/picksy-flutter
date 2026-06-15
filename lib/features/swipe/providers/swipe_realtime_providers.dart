import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/swipe_match.dart';
import 'swipe_repository_provider.dart';

final movieLikedUserIdsProvider = StreamProvider.autoDispose
    .family<List<String>, ({String roomId, int movieId})>((ref, params) {
      return ref
          .watch(swipeRepositoryProvider)
          .watchLikedUserIdsForMovie(
            roomId: params.roomId,
            movieId: params.movieId,
          );
    });

final placeLikedUserIdsProvider = StreamProvider.autoDispose
    .family<List<String>, ({String roomId, String placeId})>((ref, params) {
      return ref
          .watch(swipeRepositoryProvider)
          .watchLikedUserIdsForPlace(
            roomId: params.roomId,
            placeId: params.placeId,
          );
    });

final roomMatchesProvider = StreamProvider.autoDispose
    .family<List<SwipeMatch>, String>((ref, roomId) {
      return ref.watch(swipeRepositoryProvider).watchMatches(roomId);
    });
