// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Room {

 String get id; String get name; String get category; String get mood; String get createdBy; String get status; List<String> get members; int get memberCount; RoomFilters get filters; int get currentCardIndex; List<String> get matches; List<String> get watchlist;@TimestampDateTimeConverter() DateTime? get createdAt;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.currentCardIndex, currentCardIndex) || other.currentCardIndex == currentCardIndex)&&const DeepCollectionEquality().equals(other.matches, matches)&&const DeepCollectionEquality().equals(other.watchlist, watchlist)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,mood,createdBy,status,const DeepCollectionEquality().hash(members),memberCount,filters,currentCardIndex,const DeepCollectionEquality().hash(matches),const DeepCollectionEquality().hash(watchlist),createdAt);

@override
String toString() {
  return 'Room(id: $id, name: $name, category: $category, mood: $mood, createdBy: $createdBy, status: $status, members: $members, memberCount: $memberCount, filters: $filters, currentCardIndex: $currentCardIndex, matches: $matches, watchlist: $watchlist, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String mood, String createdBy, String status, List<String> members, int memberCount, RoomFilters filters, int currentCardIndex, List<String> matches, List<String> watchlist,@TimestampDateTimeConverter() DateTime? createdAt
});


$RoomFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? mood = null,Object? createdBy = null,Object? status = null,Object? members = null,Object? memberCount = null,Object? filters = null,Object? currentCardIndex = null,Object? matches = null,Object? watchlist = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<String>,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as RoomFilters,currentCardIndex: null == currentCardIndex ? _self.currentCardIndex : currentCardIndex // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<String>,watchlist: null == watchlist ? _self.watchlist : watchlist // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomFiltersCopyWith<$Res> get filters {
  
  return $RoomFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String mood,  String createdBy,  String status,  List<String> members,  int memberCount,  RoomFilters filters,  int currentCardIndex,  List<String> matches,  List<String> watchlist, @TimestampDateTimeConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.mood,_that.createdBy,_that.status,_that.members,_that.memberCount,_that.filters,_that.currentCardIndex,_that.matches,_that.watchlist,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String mood,  String createdBy,  String status,  List<String> members,  int memberCount,  RoomFilters filters,  int currentCardIndex,  List<String> matches,  List<String> watchlist, @TimestampDateTimeConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.id,_that.name,_that.category,_that.mood,_that.createdBy,_that.status,_that.members,_that.memberCount,_that.filters,_that.currentCardIndex,_that.matches,_that.watchlist,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String mood,  String createdBy,  String status,  List<String> members,  int memberCount,  RoomFilters filters,  int currentCardIndex,  List<String> matches,  List<String> watchlist, @TimestampDateTimeConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.mood,_that.createdBy,_that.status,_that.members,_that.memberCount,_that.filters,_that.currentCardIndex,_that.matches,_that.watchlist,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Room implements Room {
  const _Room({required this.id, required this.name, required this.category, required this.mood, required this.createdBy, required this.status, final  List<String> members = const <String>[], this.memberCount = 1, required this.filters, this.currentCardIndex = 0, final  List<String> matches = const <String>[], final  List<String> watchlist = const <String>[], @TimestampDateTimeConverter() this.createdAt}): _members = members,_matches = matches,_watchlist = watchlist;
  factory _Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
@override final  String mood;
@override final  String createdBy;
@override final  String status;
 final  List<String> _members;
@override@JsonKey() List<String> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override@JsonKey() final  int memberCount;
@override final  RoomFilters filters;
@override@JsonKey() final  int currentCardIndex;
 final  List<String> _matches;
@override@JsonKey() List<String> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}

 final  List<String> _watchlist;
@override@JsonKey() List<String> get watchlist {
  if (_watchlist is EqualUnmodifiableListView) return _watchlist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_watchlist);
}

@override@TimestampDateTimeConverter() final  DateTime? createdAt;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.currentCardIndex, currentCardIndex) || other.currentCardIndex == currentCardIndex)&&const DeepCollectionEquality().equals(other._matches, _matches)&&const DeepCollectionEquality().equals(other._watchlist, _watchlist)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,mood,createdBy,status,const DeepCollectionEquality().hash(_members),memberCount,filters,currentCardIndex,const DeepCollectionEquality().hash(_matches),const DeepCollectionEquality().hash(_watchlist),createdAt);

@override
String toString() {
  return 'Room(id: $id, name: $name, category: $category, mood: $mood, createdBy: $createdBy, status: $status, members: $members, memberCount: $memberCount, filters: $filters, currentCardIndex: $currentCardIndex, matches: $matches, watchlist: $watchlist, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String mood, String createdBy, String status, List<String> members, int memberCount, RoomFilters filters, int currentCardIndex, List<String> matches, List<String> watchlist,@TimestampDateTimeConverter() DateTime? createdAt
});


@override $RoomFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? mood = null,Object? createdBy = null,Object? status = null,Object? members = null,Object? memberCount = null,Object? filters = null,Object? currentCardIndex = null,Object? matches = null,Object? watchlist = null,Object? createdAt = freezed,}) {
  return _then(_Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<String>,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as RoomFilters,currentCardIndex: null == currentCardIndex ? _self.currentCardIndex : currentCardIndex // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<String>,watchlist: null == watchlist ? _self._watchlist : watchlist // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomFiltersCopyWith<$Res> get filters {
  
  return $RoomFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
