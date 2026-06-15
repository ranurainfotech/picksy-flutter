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
    @Default('') String locationLabel,
    @Default(0) double lat,
    @Default(0) double lng,
    @Default(5000) int radiusMeters,
    @Default(<int>[]) List<int> priceLevels,
    @Default(<String>[]) List<String> cuisineTypes,
    @Default(false) bool openNow,
  }) = _RoomFilters;

  factory RoomFilters.fromJson(Map<String, dynamic> json) =>
      _$RoomFiltersFromJson(json);
}
