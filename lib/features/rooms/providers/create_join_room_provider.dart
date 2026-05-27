import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../repositories/room_repository.dart';
import 'room_repository_provider.dart';

enum RoomDecisionCategory {
  movies('movies', 'Movies', '🍿'),
  restaurants('restaurants', 'Restaurants', '🍔'),
  activities('activities', 'Activities', '🎉');

  const RoomDecisionCategory(this.id, this.label, this.emoji);

  final String id;
  final String label;
  final String emoji;
}

class CreateJoinRoomState {
  const CreateJoinRoomState({
    required this.selectedCategory,
    required this.roomCode,
    this.errorMessage,
  });

  factory CreateJoinRoomState.initial() {
    return const CreateJoinRoomState(
      selectedCategory: RoomDecisionCategory.movies,
      roomCode: '',
    );
  }

  final RoomDecisionCategory selectedCategory;
  final String roomCode;
  final String? errorMessage;

  CreateJoinRoomState copyWith({
    RoomDecisionCategory? selectedCategory,
    String? roomCode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateJoinRoomState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      roomCode: roomCode ?? this.roomCode,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final createJoinRoomProvider =
    NotifierProvider<CreateJoinRoomNotifier, CreateJoinRoomState>(
      CreateJoinRoomNotifier.new,
    );

class CreateJoinRoomNotifier extends Notifier<CreateJoinRoomState> {
  @override
  CreateJoinRoomState build() => CreateJoinRoomState.initial();

  void selectCategory(RoomDecisionCategory category) {
    state = state.copyWith(selectedCategory: category, clearError: true);
  }

  void updateRoomCode(String roomCode) {
    state = state.copyWith(
      roomCode: roomCode.trim().toUpperCase(),
      clearError: true,
    );
  }

  bool canJoinRoom() {
    if (state.roomCode.isEmpty) {
      state = state.copyWith(errorMessage: 'Enter a room code to join.');
      return false;
    }

    return true;
  }
}

final createJoinRoomActionProvider =
    AsyncNotifierProvider<CreateJoinRoomActionNotifier, void>(
      CreateJoinRoomActionNotifier.new,
    );

class CreateJoinRoomActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> joinRoom() async {
    final formNotifier = ref.read(createJoinRoomProvider.notifier);

    if (!formNotifier.canJoinRoom()) {
      return null;
    }

    state = const AsyncLoading();

    try {
      final uid = _requireUid();
      final formState = ref.read(createJoinRoomProvider);
      final roomId = await ref
          .read(roomRepositoryProvider)
          .joinRoom(roomId: formState.roomCode, uid: uid);

      state = const AsyncData(null);
      return roomId;
    } catch (error, stackTrace) {
      state = AsyncError(_friendlyError(error), stackTrace);
      return null;
    }
  }

  String _requireUid() {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user == null) {
      throw const CreateJoinRoomException(
        'Create a session before making rooms.',
      );
    }

    return user.uid;
  }

  String _friendlyError(Object error) {
    if (error is RoomNotFoundException) {
      return 'That room code does not exist yet.';
    }

    if (error is CreateJoinRoomException) {
      return error.message;
    }

    return 'Could not update the room. Try again.';
  }
}

class CreateJoinRoomException implements Exception {
  const CreateJoinRoomException(this.message);

  final String message;
}
