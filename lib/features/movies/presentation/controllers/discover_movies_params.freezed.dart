// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_movies_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverMoviesParams {

 List<int> get genreIds; List<int> get providerIds; double get minRating; String get sortBy; int get releaseYear;
/// Create a copy of DiscoverMoviesParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverMoviesParamsCopyWith<DiscoverMoviesParams> get copyWith => _$DiscoverMoviesParamsCopyWithImpl<DiscoverMoviesParams>(this as DiscoverMoviesParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverMoviesParams&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&const DeepCollectionEquality().equals(other.providerIds, providerIds)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genreIds),const DeepCollectionEquality().hash(providerIds),minRating,sortBy,releaseYear);

@override
String toString() {
  return 'DiscoverMoviesParams(genreIds: $genreIds, providerIds: $providerIds, minRating: $minRating, sortBy: $sortBy, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class $DiscoverMoviesParamsCopyWith<$Res>  {
  factory $DiscoverMoviesParamsCopyWith(DiscoverMoviesParams value, $Res Function(DiscoverMoviesParams) _then) = _$DiscoverMoviesParamsCopyWithImpl;
@useResult
$Res call({
 List<int> genreIds, List<int> providerIds, double minRating, String sortBy, int releaseYear
});




}
/// @nodoc
class _$DiscoverMoviesParamsCopyWithImpl<$Res>
    implements $DiscoverMoviesParamsCopyWith<$Res> {
  _$DiscoverMoviesParamsCopyWithImpl(this._self, this._then);

  final DiscoverMoviesParams _self;
  final $Res Function(DiscoverMoviesParams) _then;

/// Create a copy of DiscoverMoviesParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genreIds = null,Object? providerIds = null,Object? minRating = null,Object? sortBy = null,Object? releaseYear = null,}) {
  return _then(_self.copyWith(
genreIds: null == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,providerIds: null == providerIds ? _self.providerIds : providerIds // ignore: cast_nullable_to_non_nullable
as List<int>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverMoviesParams].
extension DiscoverMoviesParamsPatterns on DiscoverMoviesParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverMoviesParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverMoviesParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverMoviesParams value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverMoviesParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverMoviesParams value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverMoviesParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> genreIds,  List<int> providerIds,  double minRating,  String sortBy,  int releaseYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverMoviesParams() when $default != null:
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.sortBy,_that.releaseYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> genreIds,  List<int> providerIds,  double minRating,  String sortBy,  int releaseYear)  $default,) {final _that = this;
switch (_that) {
case _DiscoverMoviesParams():
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.sortBy,_that.releaseYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> genreIds,  List<int> providerIds,  double minRating,  String sortBy,  int releaseYear)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverMoviesParams() when $default != null:
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.sortBy,_that.releaseYear);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverMoviesParams implements DiscoverMoviesParams {
  const _DiscoverMoviesParams({final  List<int> genreIds = const <int>[], final  List<int> providerIds = const <int>[], this.minRating = 0, this.sortBy = 'popularity.desc', required this.releaseYear}): _genreIds = genreIds,_providerIds = providerIds;
  

 final  List<int> _genreIds;
@override@JsonKey() List<int> get genreIds {
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genreIds);
}

 final  List<int> _providerIds;
@override@JsonKey() List<int> get providerIds {
  if (_providerIds is EqualUnmodifiableListView) return _providerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providerIds);
}

@override@JsonKey() final  double minRating;
@override@JsonKey() final  String sortBy;
@override final  int releaseYear;

/// Create a copy of DiscoverMoviesParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverMoviesParamsCopyWith<_DiscoverMoviesParams> get copyWith => __$DiscoverMoviesParamsCopyWithImpl<_DiscoverMoviesParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverMoviesParams&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&const DeepCollectionEquality().equals(other._providerIds, _providerIds)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genreIds),const DeepCollectionEquality().hash(_providerIds),minRating,sortBy,releaseYear);

@override
String toString() {
  return 'DiscoverMoviesParams(genreIds: $genreIds, providerIds: $providerIds, minRating: $minRating, sortBy: $sortBy, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class _$DiscoverMoviesParamsCopyWith<$Res> implements $DiscoverMoviesParamsCopyWith<$Res> {
  factory _$DiscoverMoviesParamsCopyWith(_DiscoverMoviesParams value, $Res Function(_DiscoverMoviesParams) _then) = __$DiscoverMoviesParamsCopyWithImpl;
@override @useResult
$Res call({
 List<int> genreIds, List<int> providerIds, double minRating, String sortBy, int releaseYear
});




}
/// @nodoc
class __$DiscoverMoviesParamsCopyWithImpl<$Res>
    implements _$DiscoverMoviesParamsCopyWith<$Res> {
  __$DiscoverMoviesParamsCopyWithImpl(this._self, this._then);

  final _DiscoverMoviesParams _self;
  final $Res Function(_DiscoverMoviesParams) _then;

/// Create a copy of DiscoverMoviesParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genreIds = null,Object? providerIds = null,Object? minRating = null,Object? sortBy = null,Object? releaseYear = null,}) {
  return _then(_DiscoverMoviesParams(
genreIds: null == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,providerIds: null == providerIds ? _self._providerIds : providerIds // ignore: cast_nullable_to_non_nullable
as List<int>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
