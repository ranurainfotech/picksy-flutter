import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cloud_places_repository.dart';
import '../../domain/repositories/places_repository.dart';

const _functionsRegion = 'asia-south1';

final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  return FirebaseFunctions.instanceFor(region: _functionsRegion);
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  return CloudPlacesRepository(ref.watch(firebaseFunctionsProvider));
});
