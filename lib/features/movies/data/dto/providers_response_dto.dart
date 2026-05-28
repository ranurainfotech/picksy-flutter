import 'package:freezed_annotation/freezed_annotation.dart';

import 'streaming_provider_dto.dart';

part 'providers_response_dto.freezed.dart';
part 'providers_response_dto.g.dart';

@freezed
abstract class ProvidersResponseDto with _$ProvidersResponseDto {
  const factory ProvidersResponseDto({
    @Default(<StreamingProviderDto>[])
    @JsonKey(name: 'results')
    List<StreamingProviderDto> results,
  }) = _ProvidersResponseDto;

  factory ProvidersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProvidersResponseDtoFromJson(json);
}
