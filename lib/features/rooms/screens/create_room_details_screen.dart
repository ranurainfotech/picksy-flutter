import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../movies/domain/entities/streaming_provider.dart';
import '../../movies/presentation/controllers/supported_providers.dart';
import '../../movies/presentation/providers/movies_providers.dart';
import '../providers/create_join_room_provider.dart';
import '../providers/rooms_provider.dart';
import '../providers/room_setup_provider.dart';
import '../theme/app_create_room_details_tokens.dart';

class CreateRoomDetailsScreen extends ConsumerStatefulWidget {
  const CreateRoomDetailsScreen({
    super.key,
    required this.category,
    this.editRoomId,
  });

  final RoomDecisionCategory category;
  final String? editRoomId;

  @override
  ConsumerState<CreateRoomDetailsScreen> createState() =>
      _CreateRoomDetailsScreenState();
}

class _CreateRoomDetailsScreenState extends ConsumerState<CreateRoomDetailsScreen> {
  late final TextEditingController _roomNameController;
  final FocusNode _roomNameFocus = FocusNode();
  bool _hydratedFromRoom = false;
  bool _hydrateScheduled = false;
  bool _isSyncingRoomNameFromState = false;

  @override
  void initState() {
    super.initState();
    ref.read(roomSetupProvider.notifier).bindCategory(widget.category);
    final initialName = ref.read(roomSetupProvider).roomName;
    _roomNameController = TextEditingController(text: initialName)
      ..addListener(_onRoomNameChanged);
  }

  @override
  void dispose() {
    _roomNameController
      ..removeListener(_onRoomNameChanged)
      ..dispose();
    _roomNameFocus.dispose();
    super.dispose();
  }

  void _onRoomNameChanged() {
    if (_isSyncingRoomNameFromState) {
      return;
    }
    ref.read(roomSetupProvider.notifier).updateRoomName(_roomNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(roomSetupProvider);
    final actionState = ref.watch(createRoomSetupActionProvider);
    final genresAsync = ref.watch(genresProvider);
    final providersAsync = ref.watch(streamingProvidersProvider);
    final editingRoomId = widget.editRoomId;
    final editingRoomAsync = editingRoomId == null
        ? null
        : ref.watch(roomStreamProvider(editingRoomId));
    final setupNotifier = ref.read(roomSetupProvider.notifier);
    final isLoading = actionState.isLoading;
    final errorMessage =
        setupState.errorMessage ?? actionState.error?.toString();

    if (_roomNameController.text != setupState.roomName &&
        !(_roomNameFocus.hasFocus)) {
      _isSyncingRoomNameFromState = true;
      _roomNameController.value = _roomNameController.value.copyWith(
        text: setupState.roomName,
        selection: TextSelection.collapsed(offset: setupState.roomName.length),
        composing: TextRange.empty,
      );
      _isSyncingRoomNameFromState = false;
    }

    if (editingRoomAsync != null && !_hydratedFromRoom && !_hydrateScheduled) {
      editingRoomAsync.whenData((room) {
        if (!mounted || room == null || _hydratedFromRoom || _hydrateScheduled) {
          return;
        }
        _hydrateScheduled = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _hydratedFromRoom) {
            _hydrateScheduled = false;
            return;
          }

          final filters = room['filters'] as Map<String, dynamic>? ?? const {};
          final genres = Set<int>.from(
            (filters['genreIds'] as List? ?? const <dynamic>[])
                .whereType<num>()
                .map((value) => value.toInt()),
          );
          final providers = Set<int>.from(
            (filters['providerIds'] as List? ?? const <dynamic>[])
                .whereType<num>()
                .map((value) => value.toInt()),
          );
          final minRatingRaw = filters['minRating'];
          final minRating = minRatingRaw is num ? minRatingRaw.toDouble() : 7.0;
          final releaseYearRaw = filters['releaseYear'];
          final releaseYear = releaseYearRaw is num
              ? releaseYearRaw.toInt()
              : DateTime.now().year;

          setupNotifier.hydrateFromRoomData(
            category: widget.category,
            roomName: room['name'] as String? ?? setupState.roomName,
            mood: room['mood'] as String? ?? setupState.selectedMood,
            genreIds: genres.isEmpty ? setupState.selectedGenreIds : genres,
            providerIds:
                providers.isEmpty ? setupState.selectedProviderIds : providers,
            minimumRating: minRating,
            releaseYear: releaseYear,
          );

          _hydratedFromRoom = true;
          _hydrateScheduled = false;
        });
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _CreateRoomBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppCreateRoomDetailsTokens.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppCreateRoomDetailsTokens.topBarTopMargin),
                  _CreateRoomTopBar(
                    title: editingRoomId == null ? 'Create Room' : 'Edit Room',
                    onBack: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  const SizedBox(
                    height: AppCreateRoomDetailsTokens.topBarBottomMargin,
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        bottom: AppCreateRoomDetailsTokens.ctaBottomMargin,
                      ),
                      children: [
                        const _CreateRoomHeroTitle(),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.heroBottomGap,
                        ),
                        Text(
                          'Set the mood and filters for your room',
                          style: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            fontFamilyFallback: AppTypography.fallbackFonts,
                            fontSize: AppCreateRoomDetailsTokens.subtitleFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.54),
                          ),
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.subtitleBottomGap,
                        ),
                        _SectionLabel(
                          label: 'Room Name',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.roomNameLabelBottomGap,
                        ),
                        _RoomNameField(
                          controller: _roomNameController,
                          focusNode: _roomNameFocus,
                        ),
                        const SizedBox(height: AppSpacing.tiny),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${setupState.roomName.characters.length}/30',
                            style: TextStyle(
                              fontFamily: AppTypography.primaryFont,
                              fontFamilyFallback: AppTypography.fallbackFonts,
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.38),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.roomNameFieldBottomGap,
                        ),
                        _SectionLabel(
                          label: 'Choose the mood',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.moodTitleBottomGap,
                        ),
                        _MoodGrid(
                          moods: roomMoodOptions,
                          selected: setupState.selectedMood,
                          onSelect: setupNotifier.selectMood,
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.moodSectionBottomGap,
                        ),
                        Row(
                          children: [
                            _SectionLabel(
                              label: 'Filters',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            _TactileScale(
                              onTap: setupNotifier.resetFilters,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 14,
                                    color: AppColors.neonPink,
                                  ),
                                  const SizedBox(width: AppSpacing.tiny),
                                  Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontFamily: AppTypography.primaryFont,
                                      fontFamilyFallback:
                                          AppTypography.fallbackFonts,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.neonPink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filtersHeaderBottomGap,
                        ),
                        _InlineFilterSectionTitle(
                          icon: '🎬',
                          title: 'Genres',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        genresAsync.when(
                          data: (genres) => _FilterChipWrap(
                            options: genres
                                .map(
                                  (genre) => _FilterOption(
                                    id: genre.id,
                                    label: genre.name,
                                  ),
                                )
                                .toList(growable: false),
                            selected: setupState.selectedGenreIds,
                            onToggle: setupNotifier.toggleGenreId,
                          ),
                          loading: () => const _FiltersLoading(),
                          error: (error, stack) => const _FiltersErrorText(
                            message: 'Could not load genres.',
                          ),
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        const _ThinDivider(),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        _InlineFilterSectionTitle(
                          icon: '📺',
                          title: 'Streaming Platform',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        providersAsync.when(
                          data: (providers) {
                            final providersById = {
                              for (final provider in providers) provider.id: provider,
                            };
                            final indiaProviders = <StreamingProvider>[
                              for (final id in indiaProviderIds)
                                if (providersById.containsKey(id)) providersById[id]!,
                            ];
                            final usProviders = <StreamingProvider>[
                              for (final id in usProviderIds)
                                if (providersById.containsKey(id)) providersById[id]!,
                            ];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _ProviderRegionLabel('Popular in India'),
                                const SizedBox(height: 8),
                                _ProviderChipsRow(
                                  providers: indiaProviders,
                                  selectedProviderIds: setupState.selectedProviderIds,
                                  onToggle: setupNotifier.toggleProviderId,
                                ),
                                const SizedBox(height: 12),
                                const _ProviderRegionLabel('Popular in US'),
                                const SizedBox(height: 8),
                                _ProviderChipsRow(
                                  providers: usProviders,
                                  selectedProviderIds: setupState.selectedProviderIds,
                                  onToggle: setupNotifier.toggleProviderId,
                                ),
                              ],
                            );
                          },
                          loading: () => const _FiltersLoading(),
                          error: (error, stack) => const _FiltersErrorText(
                            message: 'Could not load providers.',
                          ),
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        const _ThinDivider(),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        _InlineFilterSectionTitle(
                          icon: '⭐',
                          title: 'Minimum Rating',
                          trailingValue:
                              '${setupState.minimumRating.toStringAsFixed(1)}+',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        _RatingSlider(
                          value: setupState.minimumRating,
                          onChanged: setupNotifier.updateMinimumRating,
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        _InlineFilterSectionTitle(
                          icon: '📅',
                          title: 'Release Year',
                          trailingValue: '${setupState.releaseYear}',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        _ReleaseYearSelector(
                          selectedYear: setupState.releaseYear,
                          onChanged: setupNotifier.updateReleaseYear,
                        ),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        const _ThinDivider(),
                        const SizedBox(
                          height: AppCreateRoomDetailsTokens.filterCardGap,
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            errorMessage,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.reject,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.section),
                        AppButton.primary(
                          label: editingRoomId == null
                              ? 'Start Deciding →'
                              : 'Save Room Changes',
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (editingRoomId != null) {
                                    final saved = await ref
                                        .read(createRoomSetupActionProvider.notifier)
                                        .updateRoom(editingRoomId);
                                    if (!context.mounted || !saved) {
                                      return;
                                    }
                                    context.go(AppRoutes.roomLobby(editingRoomId));
                                  } else {
                                    final roomId = await ref
                                        .read(createRoomSetupActionProvider.notifier)
                                        .createRoom();

                                    if (!context.mounted || roomId == null) {
                                      return;
                                    }

                                    context.go(AppRoutes.roomLobby(roomId));
                                  }
                                },
                        ),
                      ],
                    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.04),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateRoomBackground extends StatelessWidget {
  const _CreateRoomBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppCreateRoomDetailsTokens.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientGlow(
            alignment: Alignment(0.95, -0.92),
            color: AppColors.electricPurple,
          ),
          const _AmbientGlow(
            alignment: Alignment(-0.9, 0.95),
            color: AppColors.neonPink,
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: AppCreateRoomDetailsTokens.ambientGlowSize,
          height: AppCreateRoomDetailsTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: AppCreateRoomDetailsTokens.ambientGlowOpacity,
                ),
                blurRadius: AppCreateRoomDetailsTokens.ambientGlowBlur,
                spreadRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateRoomTopBar extends StatelessWidget {
  const _CreateRoomTopBar({
    required this.onBack,
    required this.title,
  });

  final VoidCallback onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CreateRoomBackButton(onPressed: onBack),
        const Spacer(),
        Text(
          title,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const SizedBox(width: AppCreateRoomDetailsTokens.backButtonSize),
      ],
    );
  }
}

class _CreateRoomBackButton extends StatelessWidget {
  const _CreateRoomBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _TactileScale(
      onTap: onPressed,
      child: Container(
        width: AppCreateRoomDetailsTokens.backButtonSize,
        height: AppCreateRoomDetailsTokens.backButtonSize,
        decoration: BoxDecoration(
          color: AppCreateRoomDetailsTokens.backButtonBackground,
          borderRadius: BorderRadius.circular(
            AppCreateRoomDetailsTokens.backButtonRadius,
          ),
          border: Border.all(
            color: AppCreateRoomDetailsTokens.backButtonBorder,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}

class _CreateRoomHeroTitle extends StatelessWidget {
  const _CreateRoomHeroTitle();

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: AppTypography.primaryFont,
      fontFamilyFallback: AppTypography.fallbackFonts,
      fontSize: AppCreateRoomDetailsTokens.heroFontSize,
      height: AppCreateRoomDetailsTokens.heroLineHeight,
      fontWeight: FontWeight.w800,
      color: AppColors.primaryText,
      letterSpacing: -0.8,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's the vibe", style: titleStyle),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _HeroGradientText(
              text: 'tonight?',
              style: titleStyle,
              gradient: AppCreateRoomDetailsTokens.heroHighlightGradient,
            ),
            Text(' ✨', style: titleStyle),
          ],
        ),
      ],
    );
  }
}

class _HeroGradientText extends StatelessWidget {
  const _HeroGradientText({
    required this.text,
    required this.style,
    required this.gradient,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return Text(
      text,
      style: style.copyWith(
        foreground: Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, painter.width, painter.height),
          ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  });

  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: AppTypography.primaryFont,
        fontFamilyFallback: AppTypography.fallbackFonts,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.primaryText,
      ),
    );
  }
}

class _RoomNameField extends StatefulWidget {
  const _RoomNameField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<_RoomNameField> createState() => _RoomNameFieldState();
}

class _RoomNameFieldState extends State<_RoomNameField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;

    return SizedBox(
      height: AppCreateRoomDetailsTokens.roomNameFieldHeight,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLength: 30,
        style: TextStyle(
          fontFamily: AppTypography.primaryFont,
          fontFamilyFallback: AppTypography.fallbackFonts,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          filled: true,
          fillColor: AppCreateRoomDetailsTokens.roomNameBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          prefixIcon: const Center(
            widthFactor: 1,
            child: Text('🍿', style: TextStyle(fontSize: 16)),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          suffixIcon: GestureDetector(
            onTap: () => widget.controller.clear(),
            child: Icon(
              Icons.close_rounded,
              size: 15,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppCreateRoomDetailsTokens.roomNameFieldRadius,
            ),
            borderSide: BorderSide(
              color: focused
                  ? AppCreateRoomDetailsTokens.roomNameBorderAlt
                  : AppCreateRoomDetailsTokens.roomNameBorder,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppCreateRoomDetailsTokens.roomNameFieldRadius,
            ),
            borderSide: const BorderSide(
              color: AppCreateRoomDetailsTokens.roomNameBorderAlt,
              width: 1.4,
            ),
          ),
          // soft flowing neon aura
          focusColor: AppCreateRoomDetailsTokens.roomNameFocusGlow.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class _MoodGrid extends StatelessWidget {
  const _MoodGrid({
    required this.moods,
    required this.selected,
    required this.onSelect,
  });

  final List<RoomMoodOption> moods;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth -
                    AppCreateRoomDetailsTokens.moodGridHorizontalGap * 2) /
                3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: moods.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppCreateRoomDetailsTokens.moodGridVerticalGap,
            crossAxisSpacing: AppCreateRoomDetailsTokens.moodGridHorizontalGap,
            childAspectRatio: cellWidth / AppCreateRoomDetailsTokens.moodChipHeight,
          ),
          itemBuilder: (context, index) {
            final mood = moods[index];
            final isSelected = selected == mood.label;

            return _MoodChip(
              emoji: mood.emoji,
              label: mood.label,
              selected: isSelected,
              onTap: () => onSelect(mood.label),
            );
          },
        );
      },
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TactileScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: AppCreateRoomDetailsTokens.moodChipHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppCreateRoomDetailsTokens.moodChipBackground,
          borderRadius: BorderRadius.circular(
            AppCreateRoomDetailsTokens.moodChipRadius,
          ),
          border: Border.all(
            color: selected ? AppColors.neonPink : AppCreateRoomDetailsTokens.moodChipBorder,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.neonPink.withValues(alpha: 0.18),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: AppSpacing.tiny),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontFamilyFallback: AppTypography.fallbackFonts,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? AppColors.primaryText
                      : Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
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
          style: TextStyle(
            fontFamily: AppTypography.primaryFont,
            fontFamilyFallback: AppTypography.fallbackFonts,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const Spacer(),
        if (trailingValue != null) ...[
          Text(
            trailingValue!,
            style: TextStyle(
              fontFamily: AppTypography.primaryFont,
              fontFamilyFallback: AppTypography.fallbackFonts,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.neonPink,
            ),
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
    return Container(
      height: 1,
      color: AppColors.divider.withValues(alpha: 0.5),
    );
  }
}

class _FilterChipWrap extends StatelessWidget {
  const _FilterChipWrap({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<_FilterOption> options;
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppCreateRoomDetailsTokens.filterChipGap,
      runSpacing: AppCreateRoomDetailsTokens.filterChipGap,
      children: options
          .map(
            (option) => _FilterOptionChip(
              label: option.label,
              selected: selected.contains(option.id),
              onTap: () => onToggle(option.id),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.id, required this.label});
  final int id;
  final String label;
}

class _FilterOptionChip extends StatelessWidget {
  const _FilterOptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const genreChipHeight = 30.0;
    const selectedBorderWidth = 1.1;

    return _TactileScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: genreChipHeight + (selectedBorderWidth * 2),
        padding: const EdgeInsets.all(selectedBorderWidth),
        decoration: BoxDecoration(
          gradient: selected
              ? AppCreateRoomDetailsTokens.selectedChipGradient
              : null,
          borderRadius: BorderRadius.circular(
            AppCreateRoomDetailsTokens.filterChipRadius,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.neonPink.withValues(alpha: 0.16),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Container(
          height: genreChipHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppCreateRoomDetailsTokens.filterChipUnselected,
            borderRadius: BorderRadius.circular(
              AppCreateRoomDetailsTokens.filterChipRadius,
            ),
            border: selected
                ? null
                : Border.all(
                    color: AppColors.primaryBorder,
                    width: selectedBorderWidth,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontFamilyFallback: AppTypography.fallbackFonts,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.check_rounded,
                  size: 12,
                  color: AppColors.primaryText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderChipsRow extends StatelessWidget {
  const _ProviderChipsRow({
    required this.providers,
    required this.selectedProviderIds,
    required this.onToggle,
  });

  final List<StreamingProvider> providers;
  final Set<int> selectedProviderIds;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppCreateRoomDetailsTokens.filterChipGap,
      runSpacing: AppCreateRoomDetailsTokens.filterChipGap,
      children: providers
          .map(
            (provider) => _ProviderChipCard(
              provider: provider,
              selected: selectedProviderIds.contains(provider.id),
              onTap: () => onToggle(provider.id),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ProviderRegionLabel extends StatelessWidget {
  const _ProviderRegionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: AppTypography.primaryFont,
        fontFamilyFallback: AppTypography.fallbackFonts,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.65),
      ),
    );
  }
}

class _ProviderChipCard extends StatelessWidget {
  const _ProviderChipCard({
    required this.provider,
    required this.selected,
    required this.onTap,
  });

  final StreamingProvider provider;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const providerChipHeight = 30.0;
    const selectedBorderWidth = 1.1;
    final logoUrl = provider.logoPath == null
        ? null
        : 'https://image.tmdb.org/t/p/w92/${provider.logoPath}';

    return _TactileScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: providerChipHeight + (selectedBorderWidth * 2),
        padding: const EdgeInsets.all(selectedBorderWidth),
        decoration: BoxDecoration(
          gradient: selected
              ? AppCreateRoomDetailsTokens.selectedChipGradient
              : null,
          borderRadius: BorderRadius.circular(
            AppCreateRoomDetailsTokens.filterChipRadius,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.neonPink.withValues(alpha: 0.16),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Container(
          height: providerChipHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppCreateRoomDetailsTokens.filterChipUnselected,
            borderRadius: BorderRadius.circular(
              AppCreateRoomDetailsTokens.filterChipRadius,
            ),
            border: selected
                ? null
                : Border.all(
                    color: AppColors.primaryBorder,
                    width: selectedBorderWidth,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    logoUrl,
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.live_tv_rounded, size: 12),
                  ),
                )
              else
                const Icon(Icons.live_tv_rounded, size: 12),
              const SizedBox(width: 6),
              Text(
                provider.name,
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontFamilyFallback: AppTypography.fallbackFonts,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltersLoading extends StatelessWidget {
  const _FiltersLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 52,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _FiltersErrorText extends StatelessWidget {
  const _FiltersErrorText({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTypography.caption.copyWith(color: AppColors.reject),
    );
  }
}

class _ReleaseYearSelector extends StatelessWidget {
  const _ReleaseYearSelector({
    required this.selectedYear,
    required this.onChanged,
  });

  final int selectedYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(
      currentYear - 1979,
      (index) => currentYear - index,
      growable: false,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppCreateRoomDetailsTokens.filterChipUnselected,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: years.contains(selectedYear) ? selectedYear : years.first,
          dropdownColor: const Color(0xFF161A25),
          borderRadius: BorderRadius.circular(12),
          iconEnabledColor: AppColors.neonPink,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: years
              .map(
                (year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(
                    '$year',
                    style: const TextStyle(color: AppColors.primaryText),
                  ),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class _RatingSlider extends StatelessWidget {
  const _RatingSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: AppCreateRoomDetailsTokens.sliderTrackHeight,
            activeTrackColor: AppColors.like,
            inactiveTrackColor: AppCreateRoomDetailsTokens.filterChipUnselected,
            thumbColor: AppColors.neonPink,
            overlayColor: AppColors.neonPink.withValues(alpha: 0.16),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: AppCreateRoomDetailsTokens.sliderThumbSize / 2,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            min: AppCreateRoomDetailsTokens.sliderMin,
            max: AppCreateRoomDetailsTokens.sliderMax,
            divisions: 9,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tiny),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 1; i <= 10; i++)
                Text(
                  '$i',
                  style: TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontFamilyFallback: AppTypography.fallbackFonts,
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TactileScale extends StatefulWidget {
  const _TactileScale({
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TactileScale> createState() => _TactileScaleState();
}

class _TactileScaleState extends State<_TactileScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
