import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/room_preview.dart';
import 'room_repository_provider.dart';

final roomsProvider = StreamProvider.autoDispose<List<RoomPreview>>((ref) {
  final authState = ref.watch(authStateProvider);
  final currentUser =
      authState.asData?.value ?? ref.watch(authRepositoryProvider).currentUser;

  if (currentUser == null) {
    return Stream.value(const []);
  }

  return ref
      .watch(roomRepositoryProvider)
      .watchRoomsForUser(currentUser.uid)
      .map((snapshot) {
        final rooms = snapshot.docs.map((doc) {
          return RoomPreview.fromRoomData(roomId: doc.id, data: doc.data());
        }).toList();

        rooms.sort((a, b) => a.title.compareTo(b.title));
        return rooms;
      });
});

final roomPreviewProvider = Provider.family<RoomPreview?, String>((
  ref,
  roomId,
) {
  final rooms = ref.watch(roomsProvider).asData?.value ?? const <RoomPreview>[];

  for (final room in rooms) {
    if (room.id == roomId) {
      return room;
    }
  }

  return null;
});

final remoteRoomProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, roomId) async {
      final snapshot = await ref.watch(roomRepositoryProvider).getRoom(roomId);
      return snapshot.data();
    });

final roomStreamProvider = StreamProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, roomId) {
      return ref
          .watch(roomRepositoryProvider)
          .watchRoom(roomId)
          .map((snapshot) => snapshot.data());
    });
