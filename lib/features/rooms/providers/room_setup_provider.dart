import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_helpers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../places/presentation/providers/places_providers.dart';
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
    required this.locationLabel,
    required this.lat,
    required this.lng,
    required this.radiusKm,
    required this.selectedPriceLevels,
    required this.selectedCuisineTypes,
    required this.openNow,
    this.errorMessage,
    this.isGeocoding = false,
  });

  factory RoomSetupState.initial(RoomDecisionCategory category) {
    final defaultName = switch (category) {
      RoomDecisionCategory.restaurants => 'Dinner Plans 🍔',
      RoomDecisionCategory.activities => 'Outing Plans 🎉',
      _ => 'Saturday Night 🍿',
    };

    return RoomSetupState(
      category: category,
      roomName: defaultName,
      selectedMood: roomMoodOptions.first.label,
      selectedGenreIds: const <int>{},
      selectedProviderIds: const <int>{},
      minimumRating: category == RoomDecisionCategory.restaurants ? 3.5 : 7,
      releaseYear: 0,
      selectedSortBy: roomMoodOptions.first.tmdbSortBy,
      locationLabel: '',
      lat: 0,
      lng: 0,
      radiusKm: 5,
      selectedPriceLevels: const <int>{},
      selectedCuisineTypes: const <String>{'restaurant'},
      openNow: false,
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
  final String locationLabel;
  final double lat;
  final double lng;
  final int radiusKm;
  final Set<int> selectedPriceLevels;
  final Set<String> selectedCuisineTypes;
  final bool openNow;
  final String? errorMessage;
  final bool isGeocoding;

  bool get isRestaurant => category == RoomDecisionCategory.restaurants;

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
    String? locationLabel,
    double? lat,
    double? lng,
    int? radiusKm,
    Set<int>? selectedPriceLevels,
    Set<String>? selectedCuisineTypes,
    bool? openNow,
    String? errorMessage,
    bool clearError = false,
    bool? isGeocoding,
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
      locationLabel: locationLabel ?? this.locationLabel,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radiusKm: radiusKm ?? this.radiusKm,
      selectedPriceLevels: selectedPriceLevels ?? this.selectedPriceLevels,
      selectedCuisineTypes: selectedCuisineTypes ?? this.selectedCuisineTypes,
      openNow: openNow ?? this.openNow,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isGeocoding: isGeocoding ?? this.isGeocoding,
    );
  }

  RoomFilters toRoomFilters() {
    if (isRestaurant) {
      return RoomFilters(
        minRating: minimumRating,
        locationLabel: locationLabel.trim(),
        lat: lat,
        lng: lng,
        radiusMeters: radiusKm * 1000,
        priceLevels: selectedPriceLevels.toList()..sort(),
        cuisineTypes: selectedCuisineTypes.isEmpty
            ? const <String>['restaurant']
            : selectedCuisineTypes.toList()..sort(),
        openNow: openNow,
      );
    }

    return RoomFilters(
      genreIds: selectedGenreIds.toList()..sort(),
      providerIds: selectedProviderIds.toList()..sort(),
      minRating: minimumRating,
      releaseYear: releaseYear,
      sortBy: selectedSortBy,
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
    String locationLabel = '',
    double lat = 0,
    double lng = 0,
    int radiusKm = 5,
    Set<int> priceLevels = const <int>{},
    Set<String> cuisineTypes = const <String>{'restaurant'},
    bool openNow = false,
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
      locationLabel: locationLabel,
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
      selectedPriceLevels: priceLevels,
      selectedCuisineTypes: cuisineTypes.isEmpty
          ? const <String>{'restaurant'}
          : cuisineTypes,
      openNow: openNow,
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

  void updateLocationLabel(String label) {
    state = state.copyWith(
      locationLabel: label,
      lat: 0,
      lng: 0,
      clearError: true,
    );
  }

  void updateRadiusKm(int radiusKm) {
    state = state.copyWith(radiusKm: radiusKm.clamp(1, 15), clearError: true);
  }

  void togglePriceLevel(int level) {
    final levels = Set<int>.from(state.selectedPriceLevels);
    if (!levels.add(level)) {
      levels.remove(level);
    }
    state = state.copyWith(selectedPriceLevels: levels, clearError: true);
  }

  void toggleCuisineType(String placesType) {
    final cuisines = Set<String>.from(state.selectedCuisineTypes);
    if (placesType == 'restaurant') {
      state = state.copyWith(
        selectedCuisineTypes: const <String>{'restaurant'},
        clearError: true,
      );
      return;
    }

    cuisines.remove('restaurant');
    if (!cuisines.add(placesType)) {
      cuisines.remove(placesType);
    }
    if (cuisines.isEmpty) {
      cuisines.add('restaurant');
    }
    state = state.copyWith(selectedCuisineTypes: cuisines, clearError: true);
  }

  void updateOpenNow(bool value) {
    state = state.copyWith(openNow: value, clearError: true);
  }

  Future<bool> geocodeLocation() async {
    final query = state.locationLabel.trim();
    if (query.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Enter an area or city to continue.',
      );
      return false;
    }

    state = state.copyWith(isGeocoding: true, clearError: true);
    try {
      final result =
          await ref.read(placesRepositoryProvider).geocodeLocation(query);
      state = state.copyWith(
        locationLabel: result.label,
        lat: result.lat,
        lng: result.lng,
        isGeocoding: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isGeocoding: false,
        errorMessage: 'Could not find that area. Try a nearby landmark or city.',
      );
      return false;
    }
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

    if (state.isRestaurant) {
      if (state.locationLabel.trim().isEmpty || state.lat == 0 || state.lng == 0) {
        state = state.copyWith(
          errorMessage: 'Pick an area and tap Find location to continue.',
        );
        return false;
      }
      return true;
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
        orElse: () => roomMoodOptions.first,
      );

      final room = Room(
        id: '',
        name: formState.roomName.trim(),
        category: formState.category.id,
        mood: formState.isRestaurant ? 'Hungry ${formState.roomName.trim()}' : mood.displayLabel,
        createdBy: uid,
        status: 'waiting',
        members: [uid],
        memberCount: 1,
        filters: formState.toRoomFilters(),
      );

      final roomId = await ref.read(roomRepositoryProvider).createRoom(room: room);

      unawaited(
        ref.read(analyticsServiceProvider).logRoomCreated(
              genreCount: formState.isRestaurant
                  ? formState.selectedCuisineTypes.length
                  : formState.selectedGenreIds.length,
              providerCount: formState.isRestaurant
                  ? formState.selectedPriceLevels.length
                  : formState.selectedProviderIds.length,
              sortType: formState.isRestaurant
                  ? 'restaurants'
                  : sortTypeFromTmdb(formState.selectedSortBy),
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
        orElse: () => roomMoodOptions.first,
      );
      final filters = formState.toRoomFilters().toJson();

      await ref.read(roomRepositoryProvider).updateRoomSetup(
            roomId: roomId,
            name: formState.roomName.trim(),
            mood: formState.isRestaurant
                ? 'Hungry ${formState.roomName.trim()}'
                : mood.displayLabel,
            filters: filters,
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
