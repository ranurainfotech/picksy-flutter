// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genres_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenresResponseDto {

 List<GenreDto> get genres;
/// Create a copy of GenresResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenresResponseDtoCopyWith<GenresResponseDto> get copyWith => _$GenresResponseDtoCopyWithImpl<GenresResponseDto>(this as GenresResponseDto, _$identity);

  /// Serializes this GenresResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenresResponseDto&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'GenresResponseDto(genres: $genres)';
}


}

/// @nodoc
abstract mixin class $GenresResponseDtoCopyWith<$Res>  {
  factory $GenresResponseDtoCopyWith(GenresResponseDto value, $Res Function(GenresResponseDto) _then) = _$GenresResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<GenreDto> genres
});




}
/// @nodoc
class _$GenresResponseDtoCopyWithImpl<$Res>
    implements $GenresResponseDtoCopyWith<$Res> {
  _$GenresResponseDtoCopyWithImpl(this._self, this._then);

  final GenresResponseDto _self;
  final $Res Function(GenresResponseDto) _then;

/// Create a copy of GenresResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genres = null,}) {
  return _then(_self.copyWith(
genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenresResponseDto].
extension GenresResponseDtoPatterns on GenresResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenresResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenresResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenresResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _GenresResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenresResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _GenresResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GenreDto> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenresResponseDto() when $default != null:
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GenreDto> genres)  $default,) {final _that = this;
switch (_that) {
case _GenresResponseDto():
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GenreDto> genres)?  $default,) {final _that = this;
switch (_that) {
case _GenresResponseDto() when $default != null:
return $default(_that.genres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenresResponseDto implements GenresResponseDto {
  const _GenresResponseDto({final  List<GenreDto> genres = const <GenreDto>[]}): _genres = genres;
  factory _GenresResponseDto.fromJson(Map<String, dynamic> json) => _$GenresResponseDtoFromJson(json);

 final  List<GenreDto> _genres;
@override@JsonKey() List<GenreDto> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of GenresResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenresResponseDtoCopyWith<_GenresResponseDto> get copyWith => __$GenresResponseDtoCopyWithImpl<_GenresResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenresResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenresResponseDto&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'GenresResponseDto(genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$GenresResponseDtoCopyWith<$Res> implements $GenresResponseDtoCopyWith<$Res> {
  factory _$GenresResponseDtoCopyWith(_GenresResponseDto value, $Res Function(_GenresResponseDto) _then) = __$GenresResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<GenreDto> genres
});




}
/// @nodoc
class __$GenresResponseDtoCopyWithImpl<$Res>
    implements _$GenresResponseDtoCopyWith<$Res> {
  __$GenresResponseDtoCopyWithImpl(this._self, this._then);

  final _GenresResponseDto _self;
  final $Res Function(_GenresResponseDto) _then;

/// Create a copy of GenresResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genres = null,}) {
  return _then(_GenresResponseDto(
genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreDto>,
  ));
}


}

// dart format on
