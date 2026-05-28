// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'providers_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProvidersResponseDto {

@JsonKey(name: 'results') List<StreamingProviderDto> get results;
/// Create a copy of ProvidersResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvidersResponseDtoCopyWith<ProvidersResponseDto> get copyWith => _$ProvidersResponseDtoCopyWithImpl<ProvidersResponseDto>(this as ProvidersResponseDto, _$identity);

  /// Serializes this ProvidersResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersResponseDto&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ProvidersResponseDto(results: $results)';
}


}

/// @nodoc
abstract mixin class $ProvidersResponseDtoCopyWith<$Res>  {
  factory $ProvidersResponseDtoCopyWith(ProvidersResponseDto value, $Res Function(ProvidersResponseDto) _then) = _$ProvidersResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'results') List<StreamingProviderDto> results
});




}
/// @nodoc
class _$ProvidersResponseDtoCopyWithImpl<$Res>
    implements $ProvidersResponseDtoCopyWith<$Res> {
  _$ProvidersResponseDtoCopyWithImpl(this._self, this._then);

  final ProvidersResponseDto _self;
  final $Res Function(ProvidersResponseDto) _then;

/// Create a copy of ProvidersResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<StreamingProviderDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProvidersResponseDto].
extension ProvidersResponseDtoPatterns on ProvidersResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProvidersResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProvidersResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProvidersResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProvidersResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProvidersResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProvidersResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'results')  List<StreamingProviderDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProvidersResponseDto() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'results')  List<StreamingProviderDto> results)  $default,) {final _that = this;
switch (_that) {
case _ProvidersResponseDto():
return $default(_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'results')  List<StreamingProviderDto> results)?  $default,) {final _that = this;
switch (_that) {
case _ProvidersResponseDto() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProvidersResponseDto implements ProvidersResponseDto {
  const _ProvidersResponseDto({@JsonKey(name: 'results') final  List<StreamingProviderDto> results = const <StreamingProviderDto>[]}): _results = results;
  factory _ProvidersResponseDto.fromJson(Map<String, dynamic> json) => _$ProvidersResponseDtoFromJson(json);

 final  List<StreamingProviderDto> _results;
@override@JsonKey(name: 'results') List<StreamingProviderDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ProvidersResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvidersResponseDtoCopyWith<_ProvidersResponseDto> get copyWith => __$ProvidersResponseDtoCopyWithImpl<_ProvidersResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProvidersResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvidersResponseDto&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ProvidersResponseDto(results: $results)';
}


}

/// @nodoc
abstract mixin class _$ProvidersResponseDtoCopyWith<$Res> implements $ProvidersResponseDtoCopyWith<$Res> {
  factory _$ProvidersResponseDtoCopyWith(_ProvidersResponseDto value, $Res Function(_ProvidersResponseDto) _then) = __$ProvidersResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'results') List<StreamingProviderDto> results
});




}
/// @nodoc
class __$ProvidersResponseDtoCopyWithImpl<$Res>
    implements _$ProvidersResponseDtoCopyWith<$Res> {
  __$ProvidersResponseDtoCopyWithImpl(this._self, this._then);

  final _ProvidersResponseDto _self;
  final $Res Function(_ProvidersResponseDto) _then;

/// Create a copy of ProvidersResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_ProvidersResponseDto(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<StreamingProviderDto>,
  ));
}


}

// dart format on
