// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  mood: json['mood'] as String,
  createdBy: json['createdBy'] as String,
  status: json['status'] as String,
  members:
      (json['members'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
  filters: RoomFilters.fromJson(json['filters'] as Map<String, dynamic>),
  currentCardIndex: (json['currentCardIndex'] as num?)?.toInt() ?? 0,
  matches:
      (json['matches'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  watchlist:
      (json['watchlist'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'mood': instance.mood,
  'createdBy': instance.createdBy,
  'status': instance.status,
  'members': instance.members,
  'memberCount': instance.memberCount,
  'filters': instance.filters.toJson(),
  'currentCardIndex': instance.currentCardIndex,
  'matches': instance.matches,
  'watchlist': instance.watchlist,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
};
