import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class PlacesRepositoryException implements Exception {
  const PlacesRepositoryException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

String placesLoadErrorMessage(
  Object error, {
  required String category,
}) {
  if (error is PlacesRepositoryException) {
    return error.message;
  }

  if (error is FirebaseFunctionsException) {
    debugPrint(
      '[Places] Cloud Function error: code=${error.code} '
      'message=${error.message} details=${error.details}',
    );
    return switch (error.code) {
      'not-found' =>
        'Restaurant search is not deployed yet. Deploy Cloud Functions with searchRestaurants.',
      'failed-precondition' =>
        'Server is missing RAPIDAPI_KEY. Set the secret and redeploy functions.',
      'unauthenticated' => 'Sign in again to load restaurants.',
      'permission-denied' => 'You do not have access to restaurant search.',
      'unavailable' =>
        'Restaurant search is temporarily unavailable. Try again shortly.',
      'deadline-exceeded' =>
        'Restaurant search timed out. Try again with a smaller radius.',
      _ =>
        error.message?.trim().isNotEmpty == true
            ? error.message!.trim()
            : 'Restaurant search failed (${error.code}).',
    };
  }

  debugPrint('[Places] Unexpected error: $error');

  return category == 'restaurants'
      ? 'Could not load restaurants. Check your connection and try again.'
      : 'Could not load picks. Try again.';
}

PlacesRepositoryException mapFirebaseFunctionsException(
  FirebaseFunctionsException error,
) {
  final message = placesLoadErrorMessage(
    error,
    category: 'restaurants',
  );
  return PlacesRepositoryException(message, code: error.code);
}
