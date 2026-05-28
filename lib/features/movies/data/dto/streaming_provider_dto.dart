import 'package:freezed_annotation/freezed_annotation.dart';

part 'streaming_provider_dto.freezed.dart';
part 'streaming_provider_dto.g.dart';

@freezed
abstract class StreamingProviderDto with _$StreamingProviderDto {
  const factory StreamingProviderDto({
    @JsonKey(name: 'provider_id') required int providerId,
    @JsonKey(name: 'provider_name') required String providerName,
    @JsonKey(name: 'logo_path') String? logoPath,
  }) = _StreamingProviderDto;

  factory StreamingProviderDto.fromJson(Map<String, dynamic> json) =>
      _$StreamingProviderDtoFromJson(json);
}
