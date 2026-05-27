import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/room.dart';
import '../models/room_filters.dart';
import 'create_join_room_provider.dart';
import 'room_repository_provider.dart';

class RoomMoodOption {
  const RoomMoodOption({required this.emoji, required this.label});

  final String emoji;
  final String label;

  String get displayLabel => '$label $emoji';
}

const roomMoodOptions = <RoomMoodOption>[
  RoomMoodOption(emoji: '😊', label: 'Chill'),
  RoomMoodOption(emoji: '⚡', label: 'Hype'),
  RoomMoodOption(emoji: '🍷', label: 'Fancy'),
  RoomMoodOption(emoji: '💸', label: 'Budget'),
  RoomMoodOption(emoji: '💖', label: 'Romantic'),
  RoomMoodOption(emoji: '😈', label: 'Chaos'),
];

class RoomSetupState {
  const RoomSetupState({
    required this.category,
    required this.roomName,
    required this.selectedMood,
    required this.selectedGenres,
    required this.selectedPlatforms,
    required this.minimumRating,
    this.errorMessage,
  });

  factory RoomSetupState.initial(RoomDecisionCategory category) {
    return RoomSetupState(
      category: category,
      roomName: 'Saturday Night 🍿',
      selectedMood: roomMoodOptions.first.label,
      selectedGenres: {'Action', 'Comedy'},
      selectedPlatforms: {'Netflix', 'Prime Video'},
      minimumRating: 7,
    );
  }

  final RoomDecisionCategory category;
  final String roomName;
  final String selectedMood;
  final Set<String> selectedGenres;
  final Set<String> selectedPlatforms;
  final double minimumRating;
  final String? errorMessage;

  RoomMoodOption get selectedMoodOption {
    return roomMoodOptions.firstWhere(
      (option) => option.label == selectedMood,
      orElse: () => roomMoodOptions.first,
    );
  }

  RoomSetupState copyWith({
    RoomDecisionCategory? category,
    String? roomName,
    String? selectedMood,
    Set<String>? selectedGenres,
    Set<String>? selectedPlatforms,
    double? minimumRating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoomSetupState(
      category: category ?? this.category,
      roomName: roomName ?? this.roomName,
      selectedMood: selectedMood ?? this.selectedMood,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      selectedPlatforms: selectedPlatforms ?? this.selectedPlatforms,
      minimumRating: minimumRating ?? this.minimumRating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final roomSetupProvider =
    NotifierProvider.autoDispose<RoomSetupNotifier, RoomSetupState>(
      RoomSetupNotifier.new,
    );

class RoomSetupNotifier extends Notifier<RoomSetupState> {
  @override
  RoomSetupState build() => RoomSetupState.initial(RoomDecisionCategory.movies);

  void bindCategory(RoomDecisionCategory category) {
    if (state.category == category) {
      return;
    }

    state = RoomSetupState.initial(category);
  }

  void hydrateFromRoomData({
    required RoomDecisionCategory category,
    required String roomName,
    required String mood,
    required Set<String> genres,
    required Set<String> platforms,
    required double minimumRating,
  }) {
    final matchedMood = roomMoodOptions.firstWhere(
      (option) => mood.toLowerCase().contains(option.label.toLowerCase()),
      orElse: () => roomMoodOptions.first,
    );

    state = RoomSetupState(
      category: category,
      roomName: roomName,
      selectedMood: matchedMood.label,
      selectedGenres: genres,
      selectedPlatforms: platforms,
      minimumRating: minimumRating.clamp(1, 10),
    );
  }

  void updateRoomName(String roomName) {
    state = state.copyWith(roomName: roomName, clearError: true);
  }

  void selectMood(String mood) {
    state = state.copyWith(selectedMood: mood, clearError: true);
  }

  void toggleGenre(String genre) {
    final genres = Set<String>.from(state.selectedGenres);
    if (!genres.add(genre)) {
      genres.remove(genre);
    }
    state = state.copyWith(selectedGenres: genres, clearError: true);
  }

  void togglePlatform(String platform) {
    final platforms = Set<String>.from(state.selectedPlatforms);
    if (!platforms.add(platform)) {
      platforms.remove(platform);
    }
    state = state.copyWith(selectedPlatforms: platforms, clearError: true);
  }

  void updateMinimumRating(double rating) {
    state = state.copyWith(minimumRating: rating, clearError: true);
  }

  void resetFilters() {
    state = RoomSetupState.initial(state.category);
  }

  bool validate() {
    final trimmedName = state.roomName.trim();

    if (trimmedName.isEmpty) {
      state = state.copyWith(errorMessage: 'Enter a room name to continue.');
      return false;
    }

    if (trimmedName.length > 30) {
      state = state.copyWith(
        errorMessage: 'Room name must be 30 characters or less.',
      );
      return false;
    }

    if (state.selectedGenres.isEmpty) {
      state = state.copyWith(errorMessage: 'Select at least one genre.');
      return false;
    }

    return true;
  }
}

final createRoomSetupActionProvider =
    AsyncNotifierProvider.autoDispose<CreateRoomSetupActionNotifier, void>(
      CreateRoomSetupActionNotifier.new,
    );

class CreateRoomSetupActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> createRoom() async {
    final formNotifier = ref.read(roomSetupProvider.notifier);

    if (!formNotifier.validate()) {
      return null;
    }

    state = const AsyncLoading();

    try {
      final uid = _requireUid();
      final formState = ref.read(roomSetupProvider);
      final mood = formState.selectedMoodOption;

      final room = Room(
        id: '',
        name: formState.roomName.trim(),
        category: formState.category.id,
        mood: mood.displayLabel,
        createdBy: uid,
        status: 'waiting',
        members: [uid],
        memberCount: 1,
        filters: RoomFilters(
          genres: formState.selectedGenres.toList()..sort(),
          streamingPlatforms: formState.selectedPlatforms.toList()..sort(),
          minRating: formState.minimumRating,
        ),
      );

      final roomId = await ref.read(roomRepositoryProvider).createRoom(room: room);

      state = const AsyncData(null);
      return roomId;
    } catch (error, stackTrace) {
      state = AsyncError(_friendlyError(error), stackTrace);
      return null;
    }
  }

  Future<bool> updateRoom(String roomId) async {
    final formNotifier = ref.read(roomSetupProvider.notifier);

    if (!formNotifier.validate()) {
      return false;
    }

    state = const AsyncLoading();

    try {
      final formState = ref.read(roomSetupProvider);
      final mood = formState.selectedMoodOption;

      await ref.read(roomRepositoryProvider).updateRoomSetup(
            roomId: roomId,
            name: formState.roomName.trim(),
            mood: mood.displayLabel,
            filters: {
              'genres': formState.selectedGenres.toList()..sort(),
              'streamingPlatforms': formState.selectedPlatforms.toList()..sort(),
              'minRating': formState.minimumRating,
            },
          );

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError('Could not update room details. Try again.', stackTrace);
      return false;
    }
  }

  String _requireUid() {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user == null) {
      throw const RoomSetupException(
        'Create a session before making rooms.',
      );
    }

    return user.uid;
  }

  String _friendlyError(Object error) {
    if (error is RoomSetupException) {
      return error.message;
    }

    return 'Could not create the room. Try again.';
  }
}

class RoomSetupException implements Exception {
  const RoomSetupException(this.message);

  final String message;
}
