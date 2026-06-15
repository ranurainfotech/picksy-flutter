import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_design_system.dart';
import '../../places/constants/restaurant_cuisine_types.dart';
import '../providers/room_setup_provider.dart';
import '../theme/app_create_room_details_tokens.dart';

class RestaurantRoomFiltersSection extends ConsumerStatefulWidget {
  const RestaurantRoomFiltersSection({super.key});

  @override
  ConsumerState<RestaurantRoomFiltersSection> createState() =>
      _RestaurantRoomFiltersSectionState();
}

class _RestaurantRoomFiltersSectionState
    extends ConsumerState<RestaurantRoomFiltersSection> {
  late final TextEditingController _locationController;
  bool _syncingLocation = false;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(
      text: ref.read(roomSetupProvider).locationLabel,
    )..addListener(_onLocationChanged);
  }

  @override
  void dispose() {
    _locationController
      ..removeListener(_onLocationChanged)
      ..dispose();
    super.dispose();
  }

  void _onLocationChanged() {
    if (_syncingLocation) {
      return;
    }
    ref.read(roomSetupProvider.notifier).updateLocationLabel(
          _locationController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(roomSetupProvider);
    final setupNotifier = ref.read(roomSetupProvider.notifier);

    if (_locationController.text != setupState.locationLabel) {
      _syncingLocation = true;
      _locationController.text = setupState.locationLabel;
      _syncingLocation = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InlineFilterSectionTitle(
          icon: '📍',
          title: 'Area / City',
        ),
        const SizedBox(height: AppSpacing.small),
        TextField(
          controller: _locationController,
          style: AppTypography.bodyRegular.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Indiranagar, Bangalore',
            hintStyle: AppTypography.bodyRegular.copyWith(
              color: Colors.white.withValues(alpha: 0.35),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        AppButton.secondary(
          label: setupState.isGeocoding ? 'Finding location...' : 'Find location',
          onPressed: setupState.isGeocoding ? null : setupNotifier.geocodeLocation,
        ),
        if (setupState.lat != 0 && setupState.lng != 0) ...[
          const SizedBox(height: 8),
          Text(
            setupState.locationLabel,
            style: AppTypography.caption.copyWith(color: AppColors.neonPink),
          ),
        ],
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        const _ThinDivider(),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        _InlineFilterSectionTitle(
          icon: '📏',
          title: 'Radius',
          trailingValue: '${setupState.radiusKm} km',
        ),
        const SizedBox(height: AppSpacing.small),
        Slider(
          value: setupState.radiusKm.toDouble(),
          min: 1,
          max: 15,
          divisions: 14,
          activeColor: AppColors.neonPink,
          onChanged: (value) => setupNotifier.updateRadiusKm(value.round()),
        ),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        _InlineFilterSectionTitle(
          icon: '⭐',
          title: 'Minimum Rating',
          trailingValue: setupState.minimumRating <= 0
              ? 'Any'
              : '${setupState.minimumRating.toStringAsFixed(1)}+',
        ),
        const SizedBox(height: AppSpacing.small),
        Slider(
          value: setupState.minimumRating.clamp(0, 5),
          min: 0,
          max: 5,
          divisions: 10,
          activeColor: AppColors.neonPink,
          onChanged: setupNotifier.updateMinimumRating,
        ),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        const _ThinDivider(),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        const _InlineFilterSectionTitle(
          icon: '💰',
          title: 'Price',
        ),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in restaurantPriceLevelOptions)
              FilterChip(
                label: Text(option.label),
                selected: setupState.selectedPriceLevels.contains(option.level),
                onSelected: (_) => setupNotifier.togglePriceLevel(option.level),
                selectedColor: AppColors.neonPink.withValues(alpha: 0.25),
                checkmarkColor: AppColors.neonPink,
              ),
          ],
        ),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        const _InlineFilterSectionTitle(
          icon: '🍽️',
          title: 'Cuisine',
        ),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in restaurantCuisineOptions)
              FilterChip(
                label: Text(option.displayLabel),
                selected: setupState.selectedCuisineTypes.contains(option.placesType),
                onSelected: (_) => setupNotifier.toggleCuisineType(option.placesType),
                selectedColor: AppColors.neonPink.withValues(alpha: 0.25),
                checkmarkColor: AppColors.neonPink,
              ),
          ],
        ),
        const SizedBox(height: AppCreateRoomDetailsTokens.filterCardGap),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Open now only',
            style: AppTypography.bodyRegular.copyWith(color: Colors.white),
          ),
          value: setupState.openNow,
          activeThumbColor: AppColors.neonPink,
          onChanged: setupNotifier.updateOpenNow,
        ),
      ],
    );
  }
}

class _InlineFilterSectionTitle extends StatelessWidget {
  const _InlineFilterSectionTitle({
    required this.icon,
    required this.title,
    this.trailingValue,
  });

  final String icon;
  final String title;
  final String? trailingValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$icon $title',
          style: const TextStyle(
            fontFamily: AppTypography.primaryFont,
            fontFamilyFallback: AppTypography.fallbackFonts,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (trailingValue != null) ...[
          const Spacer(),
          Text(
            trailingValue!,
            style: AppTypography.caption.copyWith(color: AppColors.neonPink),
          ),
        ],
      ],
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
