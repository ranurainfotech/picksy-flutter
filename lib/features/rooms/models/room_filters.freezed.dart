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

 List<int> get genreIds; List<int> get providerIds; double get minRating; int get releaseYear; String get sortBy;
/// Create a copy of RoomFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomFiltersCopyWith<RoomFilters> get copyWith => _$RoomFiltersCopyWithImpl<RoomFilters>(this as RoomFilters, _$identity);

  /// Serializes this RoomFilters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFilters&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&const DeepCollectionEquality().equals(other.providerIds, providerIds)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genreIds),const DeepCollectionEquality().hash(providerIds),minRating,releaseYear,sortBy);

@override
String toString() {
  return 'RoomFilters(genreIds: $genreIds, providerIds: $providerIds, minRating: $minRating, releaseYear: $releaseYear, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $RoomFiltersCopyWith<$Res>  {
  factory $RoomFiltersCopyWith(RoomFilters value, $Res Function(RoomFilters) _then) = _$RoomFiltersCopyWithImpl;
@useResult
$Res call({
 List<int> genreIds, List<int> providerIds, double minRating, int releaseYear, String sortBy
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
@pragma('vm:prefer-inline') @override $Res call({Object? genreIds = null,Object? providerIds = null,Object? minRating = null,Object? releaseYear = null,Object? sortBy = null,}) {
  return _then(_self.copyWith(
genreIds: null == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,providerIds: null == providerIds ? _self.providerIds : providerIds // ignore: cast_nullable_to_non_nullable
as List<int>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> genreIds,  List<int> providerIds,  double minRating,  int releaseYear,  String sortBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.releaseYear,_that.sortBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> genreIds,  List<int> providerIds,  double minRating,  int releaseYear,  String sortBy)  $default,) {final _that = this;
switch (_that) {
case _RoomFilters():
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.releaseYear,_that.sortBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> genreIds,  List<int> providerIds,  double minRating,  int releaseYear,  String sortBy)?  $default,) {final _that = this;
switch (_that) {
case _RoomFilters() when $default != null:
return $default(_that.genreIds,_that.providerIds,_that.minRating,_that.releaseYear,_that.sortBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomFilters implements RoomFilters {
  const _RoomFilters({final  List<int> genreIds = const <int>[], final  List<int> providerIds = const <int>[], this.minRating = 0, this.releaseYear = 0, this.sortBy = 'popularity.desc'}): _genreIds = genreIds,_providerIds = providerIds;
  factory _RoomFilters.fromJson(Map<String, dynamic> json) => _$RoomFiltersFromJson(json);

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
@override@JsonKey() final  int releaseYear;
@override@JsonKey() final  String sortBy;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomFilters&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&const DeepCollectionEquality().equals(other._providerIds, _providerIds)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genreIds),const DeepCollectionEquality().hash(_providerIds),minRating,releaseYear,sortBy);

@override
String toString() {
  return 'RoomFilters(genreIds: $genreIds, providerIds: $providerIds, minRating: $minRating, releaseYear: $releaseYear, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class _$RoomFiltersCopyWith<$Res> implements $RoomFiltersCopyWith<$Res> {
  factory _$RoomFiltersCopyWith(_RoomFilters value, $Res Function(_RoomFilters) _then) = __$RoomFiltersCopyWithImpl;
@override @useResult
$Res call({
 List<int> genreIds, List<int> providerIds, double minRating, int releaseYear, String sortBy
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
@override @pragma('vm:prefer-inline') $Res call({Object? genreIds = null,Object? providerIds = null,Object? minRating = null,Object? releaseYear = null,Object? sortBy = null,}) {
  return _then(_RoomFilters(
genreIds: null == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,providerIds: null == providerIds ? _self._providerIds : providerIds // ignore: cast_nullable_to_non_nullable
as List<int>,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
