import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_helpers.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/room.dart';
import '../models/room_filters.dart';
import 'create_join_room_provider.dart';
import 'room_repository_provider.dart';

class RoomMoodOption {
  const RoomMoodOption({
    required this.emoji,
    required this.label,
    required this.tmdbSortBy,
  });

  final String emoji;
  final String label;
  final String tmdbSortBy;

  String get displayLabel => '$label $emoji';
}

const roomMoodOptions = <RoomMoodOption>[
  RoomMoodOption(
    emoji: '🔥',
    label: 'Popular',
    tmdbSortBy: 'popularity.desc',
  ),
  RoomMoodOption(
    emoji: '🏆',
    label: 'Top Rated',
    tmdbSortBy: 'vote_average.desc',
  ),
  RoomMoodOption(
    emoji: '📈',
    label: 'Trending',
    tmdbSortBy: 'vote_count.desc',
  ),
  RoomMoodOption(
    emoji: '🆕',
    label: 'New Releases',
    tmdbSortBy: 'primary_release_date.desc',
  ),
];

class RoomSetupState {
  const RoomSetupState({
    required this.category,
    required this.roomName,
    required this.selectedMood,
    required this.selectedGenreIds,
    required this.selectedProviderIds,
    required this.minimumRating,
    required this.releaseYear,
    required this.selectedSortBy,
    this.errorMessage,
  });

  factory RoomSetupState.initial(RoomDecisionCategory category) {
    return RoomSetupState(
      category: category,
      roomName: 'Saturday Night 🍿',
      selectedMood: roomMoodOptions.first.label,
      selectedGenreIds: const <int>{},
      selectedProviderIds: const <int>{},
      minimumRating: 7,
      releaseYear: 0,
      selectedSortBy: roomMoodOptions.first.tmdbSortBy,
    );
  }

  final RoomDecisionCategory category;
  final String roomName;
  final String selectedMood;
  final Set<int> selectedGenreIds;
  final Set<int> selectedProviderIds;
  final double minimumRating;
  final int releaseYear;
  final String selectedSortBy;
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
    Set<int>? selectedGenreIds,
    Set<int>? selectedProviderIds,
    double? minimumRating,
    int? releaseYear,
    String? selectedSortBy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoomSetupState(
      category: category ?? this.category,
      roomName: roomName ?? this.roomName,
      selectedMood: selectedMood ?? this.selectedMood,
      selectedGenreIds: selectedGenreIds ?? this.selectedGenreIds,
      selectedProviderIds: selectedProviderIds ?? this.selectedProviderIds,
      minimumRating: minimumRating ?? this.minimumRating,
      releaseYear: releaseYear ?? this.releaseYear,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
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
    required Set<int> genreIds,
    required Set<int> providerIds,
    required double minimumRating,
    required int releaseYear,
    required String sortBy,
  }) {
    final matchedMood = roomMoodOptions.firstWhere(
      (option) => mood.toLowerCase().contains(option.label.toLowerCase()),
      orElse: () => const RoomMoodOption(
        emoji: '',
        label: '',
        tmdbSortBy: '',
      ),
    );
    final matchedSortBy = roomMoodOptions.firstWhere(
      (option) => option.tmdbSortBy == sortBy,
      orElse: () => matchedMood,
    );

    state = RoomSetupState(
      category: category,
      roomName: roomName,
      selectedMood: matchedSortBy.label,
      selectedGenreIds: genreIds,
      selectedProviderIds: providerIds,
      minimumRating: minimumRating.clamp(0, 10),
      releaseYear: releaseYear,
      selectedSortBy: matchedSortBy.tmdbSortBy,
    );
  }

  void updateRoomName(String roomName) {
    state = state.copyWith(roomName: roomName, clearError: true);
  }

  void selectMood(String mood) {
    final selected = roomMoodOptions.firstWhere(
      (option) => option.label == mood,
      orElse: () => roomMoodOptions.first,
    );
    state = state.copyWith(
      selectedMood: selected.label,
      selectedSortBy: selected.tmdbSortBy,
      clearError: true,
    );
  }

  void toggleGenreId(int genreId) {
    final genres = Set<int>.from(state.selectedGenreIds);
    if (!genres.add(genreId)) {
      genres.remove(genreId);
    }
    state = state.copyWith(selectedGenreIds: genres, clearError: true);
  }

  void setSelectedGenreIds(Set<int> genreIds) {
    state = state.copyWith(
      selectedGenreIds: Set<int>.from(genreIds),
      clearError: true,
    );
  }

  void toggleProviderId(int providerId) {
    final providers = Set<int>.from(state.selectedProviderIds);
    if (!providers.add(providerId)) {
      providers.remove(providerId);
    }
    state = state.copyWith(selectedProviderIds: providers, clearError: true);
  }

  void updateMinimumRating(double rating) {
    state = state.copyWith(minimumRating: rating, clearError: true);
  }

  void updateReleaseYear(int year) {
    state = state.copyWith(releaseYear: year, clearError: true);
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

    if (state.selectedMood.trim().isEmpty || state.selectedSortBy.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Choose the mood to continue.');
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
      final mood = roomMoodOptions.firstWhere(
        (option) => option.label == formState.selectedMood,
      );

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
          genreIds: formState.selectedGenreIds.toList()..sort(),
          providerIds: formState.selectedProviderIds.toList()..sort(),
          minRating: formState.minimumRating,
          releaseYear: formState.releaseYear,
          sortBy: formState.selectedSortBy,
        ),
      );

      final roomId = await ref.read(roomRepositoryProvider).createRoom(room: room);

      unawaited(
        ref.read(analyticsServiceProvider).logRoomCreated(
              genreCount: formState.selectedGenreIds.length,
              providerCount: formState.selectedProviderIds.length,
              sortType: sortTypeFromTmdb(formState.selectedSortBy),
            ),
      );

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
      final mood = roomMoodOptions.firstWhere(
        (option) => option.label == formState.selectedMood,
      );

      await ref.read(roomRepositoryProvider).updateRoomSetup(
            roomId: roomId,
            name: formState.roomName.trim(),
            mood: mood.displayLabel,
            filters: {
              'genreIds': formState.selectedGenreIds.toList()..sort(),
              'providerIds': formState.selectedProviderIds.toList()..sort(),
              'minRating': formState.minimumRating,
              'releaseYear': formState.releaseYear,
              'sortBy': formState.selectedSortBy,
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
