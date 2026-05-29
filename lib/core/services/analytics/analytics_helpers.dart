import '../../../features/rooms/models/room_filters.dart';

String sortTypeFromTmdb(String sortBy) {
  return switch (sortBy) {
    'popularity.desc' => 'popular',
    'vote_average.desc' => 'top_rated',
    'vote_count.desc' => 'trending',
    'primary_release_date.desc' => 'new_releases',
    _ => 'other',
  };
}

String genreLabelFromFilters(RoomFilters filters) {
  if (filters.genreIds.isEmpty) {
    return 'any';
  }
  if (filters.genreIds.length == 1) {
    return 'genre_${filters.genreIds.first}';
  }
  return 'multi_genre';
}
