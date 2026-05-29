// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_movies_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiscoverMoviesResponseDto {

 List<MovieDto> get results;@JsonKey(name: 'total_pages') int get totalPages;@JsonKey(name: 'total_results') int get totalResults;
/// Create a copy of DiscoverMoviesResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverMoviesResponseDtoCopyWith<DiscoverMoviesResponseDto> get copyWith => _$DiscoverMoviesResponseDtoCopyWithImpl<DiscoverMoviesResponseDto>(this as DiscoverMoviesResponseDto, _$identity);

  /// Serializes this DiscoverMoviesResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverMoviesResponseDto&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'DiscoverMoviesResponseDto(results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $DiscoverMoviesResponseDtoCopyWith<$Res>  {
  factory $DiscoverMoviesResponseDtoCopyWith(DiscoverMoviesResponseDto value, $Res Function(DiscoverMoviesResponseDto) _then) = _$DiscoverMoviesResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<MovieDto> results,@JsonKey(name: 'total_pages') int totalPages,@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class _$DiscoverMoviesResponseDtoCopyWithImpl<$Res>
    implements $DiscoverMoviesResponseDtoCopyWith<$Res> {
  _$DiscoverMoviesResponseDtoCopyWithImpl(this._self, this._then);

  final DiscoverMoviesResponseDto _self;
  final $Res Function(DiscoverMoviesResponseDto) _then;

/// Create a copy of DiscoverMoviesResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieDto>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverMoviesResponseDto].
extension DiscoverMoviesResponseDtoPatterns on DiscoverMoviesResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverMoviesResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverMoviesResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverMoviesResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MovieDto> results, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'total_results')  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto() when $default != null:
return $default(_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MovieDto> results, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'total_results')  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto():
return $default(_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MovieDto> results, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'total_results')  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverMoviesResponseDto() when $default != null:
return $default(_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscoverMoviesResponseDto implements DiscoverMoviesResponseDto {
  const _DiscoverMoviesResponseDto({final  List<MovieDto> results = const <MovieDto>[], @JsonKey(name: 'total_pages') this.totalPages = 1, @JsonKey(name: 'total_results') this.totalResults = 0}): _results = results;
  factory _DiscoverMoviesResponseDto.fromJson(Map<String, dynamic> json) => _$DiscoverMoviesResponseDtoFromJson(json);

 final  List<MovieDto> _results;
@override@JsonKey() List<MovieDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: 'total_pages') final  int totalPages;
@override@JsonKey(name: 'total_results') final  int totalResults;

/// Create a copy of DiscoverMoviesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverMoviesResponseDtoCopyWith<_DiscoverMoviesResponseDto> get copyWith => __$DiscoverMoviesResponseDtoCopyWithImpl<_DiscoverMoviesResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscoverMoviesResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverMoviesResponseDto&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'DiscoverMoviesResponseDto(results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$DiscoverMoviesResponseDtoCopyWith<$Res> implements $DiscoverMoviesResponseDtoCopyWith<$Res> {
  factory _$DiscoverMoviesResponseDtoCopyWith(_DiscoverMoviesResponseDto value, $Res Function(_DiscoverMoviesResponseDto) _then) = __$DiscoverMoviesResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MovieDto> results,@JsonKey(name: 'total_pages') int totalPages,@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class __$DiscoverMoviesResponseDtoCopyWithImpl<$Res>
    implements _$DiscoverMoviesResponseDtoCopyWith<$Res> {
  __$DiscoverMoviesResponseDtoCopyWithImpl(this._self, this._then);

  final _DiscoverMoviesResponseDto _self;
  final $Res Function(_DiscoverMoviesResponseDto) _then;

/// Create a copy of DiscoverMoviesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_DiscoverMoviesResponseDto(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieDto>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
