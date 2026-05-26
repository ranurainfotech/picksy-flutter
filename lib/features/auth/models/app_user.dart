import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String username,
    required String avatarId,
    required bool isAnonymous,
    required int roomsCount,
    required int matchesCount,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? lastSeen,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

class TimestampDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) {
      return null;
    }

    if (json is Timestamp) {
      return json.toDate();
    }

    if (json is String) {
      return DateTime.tryParse(json);
    }

    return null;
  }

  @override
  Object? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
