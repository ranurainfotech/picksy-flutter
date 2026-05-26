// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  username: json['username'] as String,
  avatarId: json['avatarId'] as String,
  isAnonymous: json['isAnonymous'] as bool,
  roomsCount: (json['roomsCount'] as num).toInt(),
  matchesCount: (json['matchesCount'] as num).toInt(),
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
  lastSeen: const TimestampDateTimeConverter().fromJson(json['lastSeen']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'username': instance.username,
  'avatarId': instance.avatarId,
  'isAnonymous': instance.isAnonymous,
  'roomsCount': instance.roomsCount,
  'matchesCount': instance.matchesCount,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'lastSeen': const TimestampDateTimeConverter().toJson(instance.lastSeen),
};
