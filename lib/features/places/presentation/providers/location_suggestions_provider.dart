import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/restaurant_filter_limits.dart';
import '../../domain/entities/location_suggestion.dart';
import '../../places_load_errors.dart';
import 'places_providers.dart';

class LocationSearchState {
  const LocationSearchState({
    this.suggestions = const <LocationSuggestion>[],
    this.isLoading = false,
    this.errorMessage,
    this.hasSearched = false,
  });

  final List<LocationSuggestion> suggestions;
  final bool isLoading;
  final String? errorMessage;
  final bool hasSearched;

  LocationSearchState copyWith({
    List<LocationSuggestion>? suggestions,
    bool? isLoading,
    String? errorMessage,
    bool? hasSearched,
    bool clearError = false,
  }) {
    return LocationSearchState(
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }
}

final locationSuggestionsProvider =
    NotifierProvider<LocationSuggestionsNotifier, LocationSearchState>(
      LocationSuggestionsNotifier.new,
    );

class LocationSuggestionsNotifier extends Notifier<LocationSearchState> {
  Timer? _debounceTimer;
  int _requestGeneration = 0;
  String _scheduledQuery = '';
  String _lastFetchedQuery = '';

  @override
  LocationSearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const LocationSearchState();
  }

  void onQueryChanged(String query, {required bool isFieldFocused}) {
    _debounceTimer?.cancel();

    if (!isFieldFocused) {
      return;
    }

    final normalized = query.trim();
    if (normalized.length < RestaurantFilterLimits.minLocationQueryLength) {
      _scheduledQuery = '';
      _requestGeneration++;
      state = const LocationSearchState();
      return;
    }

    if (normalized == _lastFetchedQuery && state.suggestions.isNotEmpty) {
      state = state.copyWith(clearError: true);
      return;
    }

    _scheduledQuery = normalized;
    state = state.copyWith(isLoading: false, clearError: true);

    _debounceTimer = Timer(RestaurantFilterLimits.locationSearchDebounce, () {
      unawaited(_fetch(normalized));
    });
  }

  Future<void> _fetch(String query) async {
    if (query != _scheduledQuery) {
      return;
    }

    if (query == _lastFetchedQuery && state.suggestions.isNotEmpty) {
      return;
    }

    final generation = ++_requestGeneration;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final suggestions = await ref
          .read(placesRepositoryProvider)
          .searchLocationSuggestions(query);

      if (generation != _requestGeneration || query != _scheduledQuery) {
        return;
      }

      _lastFetchedQuery = query;
      state = LocationSearchState(
        suggestions: suggestions,
        hasSearched: true,
      );
    } catch (error) {
      if (generation != _requestGeneration || query != _scheduledQuery) {
        return;
      }

      state = LocationSearchState(
        isLoading: false,
        hasSearched: true,
        errorMessage: error is PlacesRepositoryException
            ? error.message
            : 'Could not search locations. Try again.',
      );
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    _scheduledQuery = '';
    _lastFetchedQuery = '';
    _requestGeneration++;
    state = const LocationSearchState();
  }
}
