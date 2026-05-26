// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get uid; String get username; String get avatarId; bool get isAnonymous; int get roomsCount; int get matchesCount;@TimestampDateTimeConverter() DateTime? get createdAt;@TimestampDateTimeConverter() DateTime? get lastSeen;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.roomsCount, roomsCount) || other.roomsCount == roomsCount)&&(identical(other.matchesCount, matchesCount) || other.matchesCount == matchesCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,avatarId,isAnonymous,roomsCount,matchesCount,createdAt,lastSeen);

@override
String toString() {
  return 'AppUser(uid: $uid, username: $username, avatarId: $avatarId, isAnonymous: $isAnonymous, roomsCount: $roomsCount, matchesCount: $matchesCount, createdAt: $createdAt, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String uid, String username, String avatarId, bool isAnonymous, int roomsCount, int matchesCount,@TimestampDateTimeConverter() DateTime? createdAt,@TimestampDateTimeConverter() DateTime? lastSeen
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? username = null,Object? avatarId = null,Object? isAnonymous = null,Object? roomsCount = null,Object? matchesCount = null,Object? createdAt = freezed,Object? lastSeen = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarId: null == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,roomsCount: null == roomsCount ? _self.roomsCount : roomsCount // ignore: cast_nullable_to_non_nullable
as int,matchesCount: null == matchesCount ? _self.matchesCount : matchesCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String username,  String avatarId,  bool isAnonymous,  int roomsCount,  int matchesCount, @TimestampDateTimeConverter()  DateTime? createdAt, @TimestampDateTimeConverter()  DateTime? lastSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.username,_that.avatarId,_that.isAnonymous,_that.roomsCount,_that.matchesCount,_that.createdAt,_that.lastSeen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String username,  String avatarId,  bool isAnonymous,  int roomsCount,  int matchesCount, @TimestampDateTimeConverter()  DateTime? createdAt, @TimestampDateTimeConverter()  DateTime? lastSeen)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.uid,_that.username,_that.avatarId,_that.isAnonymous,_that.roomsCount,_that.matchesCount,_that.createdAt,_that.lastSeen);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String username,  String avatarId,  bool isAnonymous,  int roomsCount,  int matchesCount, @TimestampDateTimeConverter()  DateTime? createdAt, @TimestampDateTimeConverter()  DateTime? lastSeen)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.username,_that.avatarId,_that.isAnonymous,_that.roomsCount,_that.matchesCount,_that.createdAt,_that.lastSeen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.uid, required this.username, required this.avatarId, required this.isAnonymous, required this.roomsCount, required this.matchesCount, @TimestampDateTimeConverter() this.createdAt, @TimestampDateTimeConverter() this.lastSeen});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String uid;
@override final  String username;
@override final  String avatarId;
@override final  bool isAnonymous;
@override final  int roomsCount;
@override final  int matchesCount;
@override@TimestampDateTimeConverter() final  DateTime? createdAt;
@override@TimestampDateTimeConverter() final  DateTime? lastSeen;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.roomsCount, roomsCount) || other.roomsCount == roomsCount)&&(identical(other.matchesCount, matchesCount) || other.matchesCount == matchesCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,avatarId,isAnonymous,roomsCount,matchesCount,createdAt,lastSeen);

@override
String toString() {
  return 'AppUser(uid: $uid, username: $username, avatarId: $avatarId, isAnonymous: $isAnonymous, roomsCount: $roomsCount, matchesCount: $matchesCount, createdAt: $createdAt, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String username, String avatarId, bool isAnonymous, int roomsCount, int matchesCount,@TimestampDateTimeConverter() DateTime? createdAt,@TimestampDateTimeConverter() DateTime? lastSeen
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = null,Object? avatarId = null,Object? isAnonymous = null,Object? roomsCount = null,Object? matchesCount = null,Object? createdAt = freezed,Object? lastSeen = freezed,}) {
  return _then(_AppUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarId: null == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,roomsCount: null == roomsCount ? _self.roomsCount : roomsCount // ignore: cast_nullable_to_non_nullable
as int,matchesCount: null == matchesCount ? _self.matchesCount : matchesCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
