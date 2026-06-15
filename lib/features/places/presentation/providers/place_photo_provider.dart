import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'places_providers.dart';

final placePhotoUrlProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, photoName) async {
      final normalized = photoName.trim();
      if (normalized.isEmpty) {
        return null;
      }

      return ref.read(placesRepositoryProvider).resolvePlacePhoto(normalized);
    });
