import 'package:freezed_annotation/freezed_annotation.dart';

part 'streaming_provider.freezed.dart';

@freezed
abstract class StreamingProvider with _$StreamingProvider {
  const factory StreamingProvider({
    required int id,
    required String name,
    String? logoPath,
  }) = _StreamingProvider;
}
