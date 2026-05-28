// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProvidersResponseDto _$ProvidersResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProvidersResponseDto(
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => StreamingProviderDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StreamingProviderDto>[],
);

Map<String, dynamic> _$ProvidersResponseDtoToJson(
  _ProvidersResponseDto instance,
) => <String, dynamic>{'results': instance.results};
