import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/presentation/providers/movies_providers.dart';
import '../../rooms/providers/room_repository_provider.dart';
import '../../swipe/providers/swipe_repository_provider.dart';
import '../models/match_feed_item.dart';
import '../repositories/matches_repository.dart';

final matchesRepositoryProvider = Provider<MatchesRepository>((ref) {
  return MatchesRepository(
    ref.watch(roomRepositoryProvider),
    ref.watch(swipeRepositoryProvider),
  );
});

final matchesFeedProvider = StreamProvider.autoDispose<List<MatchFeedItem>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final currentUser =
      authState.asData?.value ?? ref.watch(authRepositoryProvider).currentUser;

  if (currentUser == null) {
    return Stream.value(const <MatchFeedItem>[]);
  }

  return ref.watch(matchesRepositoryProvider).watchFeedForUser(currentUser.uid);
});

final matchFeedItemProvider = FutureProvider.autoDispose
    .family<MatchFeedItem?, ({String roomId, int itemId})>((ref, params) {
      return ref.read(matchesRepositoryProvider).getMatch(
        roomId: params.roomId,
        itemId: params.itemId,
      );
    });

final movieDetailsProvider = FutureProvider.autoDispose.family<Movie?, int>((
  ref,
  movieId,
) {
  return ref.watch(moviesRepositoryProvider).getMovieById(movieId);
});
