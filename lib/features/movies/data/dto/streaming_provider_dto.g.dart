// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_provider_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreamingProviderDto _$StreamingProviderDtoFromJson(
  Map<String, dynamic> json,
) => _StreamingProviderDto(
  providerId: (json['provider_id'] as num).toInt(),
  providerName: json['provider_name'] as String,
  logoPath: json['logo_path'] as String?,
);

Map<String, dynamic> _$StreamingProviderDtoToJson(
  _StreamingProviderDto instance,
) => <String, dynamic>{
  'provider_id': instance.providerId,
  'provider_name': instance.providerName,
  'logo_path': instance.logoPath,
};
