import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_filters.freezed.dart';
part 'room_filters.g.dart';

@freezed
abstract class RoomFilters with _$RoomFilters {
  const factory RoomFilters({
    @Default(<int>[]) List<int> genreIds,
    @Default(<int>[]) List<int> providerIds,
    @Default(0) double minRating,
    @Default(0) int releaseYear,
    @Default('popularity.desc') String sortBy,
  }) = _RoomFilters;

  factory RoomFilters.fromJson(Map<String, dynamic> json) =>
      _$RoomFiltersFromJson(json);
}
