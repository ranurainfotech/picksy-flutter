import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../providers/create_join_room_provider.dart';
import '../providers/room_setup_provider.dart';
import '../theme/app_create_room_details_tokens.dart';

class CreateRoomDetailsScreen extends ConsumerStatefulWidget {
  const CreateRoomDetailsScreen({super.key, required this.category});

  final RoomDecisionCategory category;

  @override
  ConsumerState<CreateRoomDetailsScreen> createState() =>
      _CreateRoomDetailsScreenState();
}

class _CreateRoomDetailsScreenState extends ConsumerState<CreateRoomDetailsScreen> {
  late final TextEditingController _roomNameController;
  final FocusNode _roomNameFocus = FocusNode();

  static const List<String> _genres = [
    'Action',
    'Comedy',
    'Sci-Fi',
    'Horror',
    'Drama',
  ];

  static const List<String> _platforms = [
    'Netflix',
    'Prime Video',
    'Disney+',
    'Apple TV+',
  ];

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
    ref.read(roomSetupProvider.notifier).updateRoomName(_roomNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(roomSetupProvider);
    final actionState = ref.watch(createRoomSetupActionProvider);
    final setupNotifier = ref.read(roomSetupProvider.notifier);
    final isLoading = actionState.isLoading;
    final errorMessage =
        setupState.errorMessage ?? actionState.error?.toString();

    if (_roomNameController.text != setupState.roomName &&
        !(_roomNameFocus.hasFocus)) {
      _roomNameController.text = setupState.roomName;
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
                        _FilterChipWrap(
                          options: _genres,
                          selected: setupState.selectedGenres,
                          onToggle: setupNotifier.toggleGenre,
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
                        _FilterChipWrap(
                          options: _platforms,
                          selected: setupState.selectedPlatforms,
                          onToggle: setupNotifier.togglePlatform,
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
                          label: 'Start Deciding →',
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final roomId = await ref
                                      .read(createRoomSetupActionProvider.notifier)
                                      .createRoom();

                                  if (!context.mounted || roomId == null) {
                                    return;
                                  }

                                  context.go(AppRoutes.roomLobby(roomId));
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
  const _CreateRoomTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CreateRoomBackButton(onPressed: onBack),
        const Spacer(),
        Text(
          'Create Room',
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

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppCreateRoomDetailsTokens.filterChipHeight + 14,
      child: ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
            stops: [0, 0.06, 0.94, 1],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          itemCount: options.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: AppCreateRoomDetailsTokens.filterChipGap),
          itemBuilder: (context, index) {
            final option = options[index];
            return _FilterOptionChip(
              label: option,
              selected: selected.contains(option),
              onTap: () => onToggle(option),
            );
          },
        ),
      ),
    );
  }
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
    const selectedBorderWidth = 1.1;

    return _TactileScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: AppCreateRoomDetailsTokens.filterChipHeight +
            (selectedBorderWidth * 2),
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
          height: AppCreateRoomDetailsTokens.filterChipHeight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.tiny),
                const Icon(
                  Icons.check_rounded,
                  size: 14,
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
