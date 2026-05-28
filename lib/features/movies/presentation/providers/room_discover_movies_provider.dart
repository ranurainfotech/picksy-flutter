import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie.dart';
import '../../../rooms/models/room_filters.dart';
import '../../../rooms/providers/rooms_provider.dart';
import '../controllers/discover_movies_params.dart';
import 'movies_providers.dart';

final roomDiscoverMoviesProvider = FutureProvider.autoDispose
    .family<List<Movie>, String>((ref, roomId) async {
      final roomData = await ref.watch(remoteRoomProvider(roomId).future);
      if (roomData == null) {
        return const <Movie>[];
      }

      final rawFilters = roomData['filters'];
      final filters = rawFilters is Map<String, dynamic>
          ? RoomFilters.fromJson(rawFilters)
          : const RoomFilters();

      final params = DiscoverMoviesParams(
        genreIds: filters.genreIds,
        providerIds: filters.providerIds,
        minRating: filters.minRating,
        sortBy: filters.sortBy,
        releaseYear: filters.releaseYear,
      );

      return ref.watch(discoverMoviesProvider(params).future);
    });
