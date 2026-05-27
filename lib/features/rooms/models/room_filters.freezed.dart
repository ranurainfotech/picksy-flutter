// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomFilters {

 List<String> get genres; List<String> get streamingPlatforms; double get minRating;
/// Create a copy of RoomFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomFiltersCopyWith<RoomFilters> get copyWith => _$RoomFiltersCopyWithImpl<RoomFilters>(this as RoomFilters, _$identity);

  /// Serializes this RoomFilters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFilters&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.streamingPlatforms, streamingPlatforms)&&(identical(other.minRating, minRating) || other.minRating == minRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(streamingPlatforms),minRating);

@override
String toString() {
  return 'RoomFilters(genres: $genres, streamingPlatforms: $streamingPlatforms, minRating: $minRating)';
}


}

/// @nodoc
abstract mixin class $RoomFiltersCopyWith<$Res>  {
  factory $RoomFiltersCopyWith(RoomFilters value, $Res Function(RoomFilters) _then) = _$RoomFiltersCopyWithImpl;
@useResult
$Res call({
 List<String> genres, List<String> streamingPlatforms, double minRating
});




}
/// @nodoc
class _$RoomFiltersCopyWithImpl<$Res>
    implements $RoomFiltersCopyWith<$Res> {
  _$RoomFiltersCopyWithImpl(this._self, this._then);

  final RoomFilters _self;
  final $Res Function(RoomFilters) _then;

/// Create a copy of RoomFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genres = null,Object? streamingPlatforms = null,Object? minRating = null,}) {
  return _then(_self.copyWith(
genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,streamingPlatforms: null == streamingPlatforms ? _self.streamingPlatforms : streamingPlatforms // ignore: cast_nullable_to_non_nullable
as List<String>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomFilters].
extension RoomFiltersPatterns on RoomFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomFilters value)  $default,){
final _that = this;
switch (_that) {
case _RoomFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomFilters value)?  $default,){
final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> genres,  List<String> streamingPlatforms,  double minRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
return $default(_that.genres,_that.streamingPlatforms,_that.minRating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> genres,  List<String> streamingPlatforms,  double minRating)  $default,) {final _that = this;
switch (_that) {
case _RoomFilters():
return $default(_that.genres,_that.streamingPlatforms,_that.minRating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> genres,  List<String> streamingPlatforms,  double minRating)?  $default,) {final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
return $default(_that.genres,_that.streamingPlatforms,_that.minRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomFilters implements RoomFilters {
  const _RoomFilters({final  List<String> genres = const <String>[], final  List<String> streamingPlatforms = const <String>[], this.minRating = 0}): _genres = genres,_streamingPlatforms = streamingPlatforms;
  factory _RoomFilters.fromJson(Map<String, dynamic> json) => _$RoomFiltersFromJson(json);

 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _streamingPlatforms;
@override@JsonKey() List<String> get streamingPlatforms {
  if (_streamingPlatforms is EqualUnmodifiableListView) return _streamingPlatforms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_streamingPlatforms);
}

@override@JsonKey() final  double minRating;

/// Create a copy of RoomFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomFiltersCopyWith<_RoomFilters> get copyWith => __$RoomFiltersCopyWithImpl<_RoomFilters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomFiltersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomFilters&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._streamingPlatforms, _streamingPlatforms)&&(identical(other.minRating, minRating) || other.minRating == minRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_streamingPlatforms),minRating);

@override
String toString() {
  return 'RoomFilters(genres: $genres, streamingPlatforms: $streamingPlatforms, minRating: $minRating)';
}


}

/// @nodoc
abstract mixin class _$RoomFiltersCopyWith<$Res> implements $RoomFiltersCopyWith<$Res> {
  factory _$RoomFiltersCopyWith(_RoomFilters value, $Res Function(_RoomFilters) _then) = __$RoomFiltersCopyWithImpl;
@override @useResult
$Res call({
 List<String> genres, List<String> streamingPlatforms, double minRating
});




}
/// @nodoc
class __$RoomFiltersCopyWithImpl<$Res>
    implements _$RoomFiltersCopyWith<$Res> {
  __$RoomFiltersCopyWithImpl(this._self, this._then);

  final _RoomFilters _self;
  final $Res Function(_RoomFilters) _then;

/// Create a copy of RoomFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genres = null,Object? streamingPlatforms = null,Object? minRating = null,}) {
  return _then(_RoomFilters(
genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,streamingPlatforms: null == streamingPlatforms ? _self._streamingPlatforms : streamingPlatforms // ignore: cast_nullable_to_non_nullable
as List<String>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
