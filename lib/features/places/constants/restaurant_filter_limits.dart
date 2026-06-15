abstract final class RestaurantFilterLimits {
  static const int minRadiusKm = 1;
  static const int maxRadiusKm = 40;
  static const int defaultRadiusKm = 10;

  /// Minimum characters before a location search is considered.
  static const int minLocationQueryLength = 3;

  /// Wait for the user to pause typing before calling Places autocomplete.
  static const Duration locationSearchDebounce = Duration(milliseconds: 800);

  /// Area / City field height — shared by the TextField and suggestion rows.
  static const double locationSearchFieldHeight = 48;
}
