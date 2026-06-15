import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../../places/constants/restaurant_filter_limits.dart';
import '../../places/domain/entities/location_suggestion.dart';

class LocationSuggestionList extends StatelessWidget {
  const LocationSuggestionList({
    super.key,
    required this.suggestions,
    required this.isLoading,
    required this.errorMessage,
    required this.hasSearched,
    required this.showPanel,
    required this.onSuggestionSelected,
  });

  final List<LocationSuggestion> suggestions;
  final bool isLoading;
  final String? errorMessage;
  final bool hasSearched;
  final bool showPanel;
  final ValueChanged<LocationSuggestion> onSuggestionSelected;

  static const double _fieldHeight =
      RestaurantFilterLimits.locationSearchFieldHeight;

  @override
  Widget build(BuildContext context) {
    if (!showPanel) {
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.small),
        child: SizedBox(
          height: _fieldHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.neonPink,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.small),
        child: Text(
          errorMessage!,
          style: AppTypography.caption.copyWith(color: AppColors.reject),
        ),
      );
    }

    if (hasSearched && suggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.small),
        child: Text(
          'No locations found. Try a city, area, or landmark.',
          style: AppTypography.caption.copyWith(
            color: AppColors.tertiaryText,
          ),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.small),
      child: SizedBox(
        height: _fieldHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemExtent: _fieldHeight,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSuggestionSelected(suggestion),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.neonPink,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: Text(
                              suggestion.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyRegular.copyWith(
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
