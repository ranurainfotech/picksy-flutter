import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/providers/user_repository_provider.dart';
import '../repositories/room_repository.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository(ref.watch(firestoreProvider));
});
