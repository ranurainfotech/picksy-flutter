// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streaming_provider_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreamingProviderDto {

@JsonKey(name: 'provider_id') int get providerId;@JsonKey(name: 'provider_name') String get providerName;@JsonKey(name: 'logo_path') String? get logoPath;
/// Create a copy of StreamingProviderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamingProviderDtoCopyWith<StreamingProviderDto> get copyWith => _$StreamingProviderDtoCopyWithImpl<StreamingProviderDto>(this as StreamingProviderDto, _$identity);

  /// Serializes this StreamingProviderDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamingProviderDto&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,logoPath);

@override
String toString() {
  return 'StreamingProviderDto(providerId: $providerId, providerName: $providerName, logoPath: $logoPath)';
}


}

/// @nodoc
abstract mixin class $StreamingProviderDtoCopyWith<$Res>  {
  factory $StreamingProviderDtoCopyWith(StreamingProviderDto value, $Res Function(StreamingProviderDto) _then) = _$StreamingProviderDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provider_id') int providerId,@JsonKey(name: 'provider_name') String providerName,@JsonKey(name: 'logo_path') String? logoPath
});




}
/// @nodoc
class _$StreamingProviderDtoCopyWithImpl<$Res>
    implements $StreamingProviderDtoCopyWith<$Res> {
  _$StreamingProviderDtoCopyWithImpl(this._self, this._then);

  final StreamingProviderDto _self;
  final $Res Function(StreamingProviderDto) _then;

/// Create a copy of StreamingProviderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providerId = null,Object? providerName = null,Object? logoPath = freezed,}) {
  return _then(_self.copyWith(
providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamingProviderDto].
extension StreamingProviderDtoPatterns on StreamingProviderDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamingProviderDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamingProviderDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamingProviderDto value)  $default,){
final _that = this;
switch (_that) {
case _StreamingProviderDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamingProviderDto value)?  $default,){
final _that = this;
switch (_that) {
case _StreamingProviderDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider_id')  int providerId, @JsonKey(name: 'provider_name')  String providerName, @JsonKey(name: 'logo_path')  String? logoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamingProviderDto() when $default != null:
return $default(_that.providerId,_that.providerName,_that.logoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider_id')  int providerId, @JsonKey(name: 'provider_name')  String providerName, @JsonKey(name: 'logo_path')  String? logoPath)  $default,) {final _that = this;
switch (_that) {
case _StreamingProviderDto():
return $default(_that.providerId,_that.providerName,_that.logoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'provider_id')  int providerId, @JsonKey(name: 'provider_name')  String providerName, @JsonKey(name: 'logo_path')  String? logoPath)?  $default,) {final _that = this;
switch (_that) {
case _StreamingProviderDto() when $default != null:
return $default(_that.providerId,_that.providerName,_that.logoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreamingProviderDto implements StreamingProviderDto {
  const _StreamingProviderDto({@JsonKey(name: 'provider_id') required this.providerId, @JsonKey(name: 'provider_name') required this.providerName, @JsonKey(name: 'logo_path') this.logoPath});
  factory _StreamingProviderDto.fromJson(Map<String, dynamic> json) => _$StreamingProviderDtoFromJson(json);

@override@JsonKey(name: 'provider_id') final  int providerId;
@override@JsonKey(name: 'provider_name') final  String providerName;
@override@JsonKey(name: 'logo_path') final  String? logoPath;

/// Create a copy of StreamingProviderDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamingProviderDtoCopyWith<_StreamingProviderDto> get copyWith => __$StreamingProviderDtoCopyWithImpl<_StreamingProviderDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreamingProviderDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamingProviderDto&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,logoPath);

@override
String toString() {
  return 'StreamingProviderDto(providerId: $providerId, providerName: $providerName, logoPath: $logoPath)';
}


}

/// @nodoc
abstract mixin class _$StreamingProviderDtoCopyWith<$Res> implements $StreamingProviderDtoCopyWith<$Res> {
  factory _$StreamingProviderDtoCopyWith(_StreamingProviderDto value, $Res Function(_StreamingProviderDto) _then) = __$StreamingProviderDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provider_id') int providerId,@JsonKey(name: 'provider_name') String providerName,@JsonKey(name: 'logo_path') String? logoPath
});




}
/// @nodoc
class __$StreamingProviderDtoCopyWithImpl<$Res>
    implements _$StreamingProviderDtoCopyWith<$Res> {
  __$StreamingProviderDtoCopyWithImpl(this._self, this._then);

  final _StreamingProviderDto _self;
  final $Res Function(_StreamingProviderDto) _then;

/// Create a copy of StreamingProviderDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providerId = null,Object? providerName = null,Object? logoPath = freezed,}) {
  return _then(_StreamingProviderDto(
providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
