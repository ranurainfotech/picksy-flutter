import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_filters.freezed.dart';
part 'room_filters.g.dart';

@freezed
abstract class RoomFilters with _$RoomFilters {
  const factory RoomFilters({
    @Default(<String>[]) List<String> genres,
    @Default(<String>[]) List<String> streamingPlatforms,
    @Default(0) double minRating,
  }) = _RoomFilters;

  factory RoomFilters.fromJson(Map<String, dynamic> json) =>
      _$RoomFiltersFromJson(json);
}
