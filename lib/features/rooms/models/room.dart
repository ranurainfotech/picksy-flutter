import 'package:freezed_annotation/freezed_annotation.dart';

import 'room_filters.dart';
import 'room_timestamp_converter.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  @JsonSerializable(explicitToJson: true)
  const factory Room({
    required String id,
    required String name,
    required String category,
    required String mood,
    required String createdBy,
    required String status,
    @Default(<String>[]) List<String> members,
    @Default(1) int memberCount,
    required RoomFilters filters,
    @Default(0) int currentCardIndex,
    @Default(<String>[]) List<String> matches,
    @Default(<String>[]) List<String> watchlist,
    @TimestampDateTimeConverter() DateTime? createdAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
