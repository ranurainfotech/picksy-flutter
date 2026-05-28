import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/room_preview.dart';
import '../providers/room_repository_provider.dart';
import '../providers/rooms_provider.dart';

class RoomLobbyScreen extends ConsumerWidget {
  const RoomLobbyScreen({
    super.key,
    required this.roomId,
    this.suppressAutoRedirectToSwipe = false,
  });
  final String roomId;
  final bool suppressAutoRedirectToSwipe;
  static const String _defaultInviteBaseUrl = String.fromEnvironment(
    'PICKSY_INVITE_BASE_URL',
    defaultValue: 'https://picksy.app',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomId));
    return roomAsync.when(
      data: (room) {
        if (room == null) return const _MissingRoomView();
        final user =
            ref.watch(authStateProvider).asData?.value ??
            ref.watch(authRepositoryProvider).currentUser;
        final uid = user?.uid;
        final members = List<String>.from(
          room['members'] as List? ?? const <String>[],
        );
        final memberCount =
            ((room['memberCount'] as int?) ?? 0) > members.length
            ? (room['memberCount'] as int?) ?? 0
            : members.length;
        final isHost = uid != null && room['createdBy'] == uid;
        final status = (room['status'] as String? ?? 'waiting').toLowerCase();
        final roomName = room['name'] as String? ?? '$roomId Room';
        final category = room['category'] as String? ?? 'movies';

        if (status == 'active' && !suppressAutoRedirectToSwipe) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(AppRoutes.roomSwipe(roomId));
          });
        }

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xFF070B14)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _Glow(
                  align: Alignment(0.9, -0.85),
                  color: AppColors.electricPurple,
                ),
                const _Glow(
                  align: Alignment(-0.88, 0.95),
                  color: AppColors.neonPink,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _TopBar(
                              onBack: () => context.go(AppRoutes.home),
                              onSettings: () => context.push(
                                AppRoutes.roomSetup,
                                extra: <String, dynamic>{
                                  'roomId': roomId,
                                  'category': category,
                                  'mode': 'edit',
                                },
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 220.ms)
                            .slideY(begin: -0.08, curve: Curves.easeOutCubic),
                        const SizedBox(height: 32),
                        _AvatarRow(memberCount: memberCount)
                            .animate()
                            .fadeIn(delay: 60.ms, duration: 260.ms)
                            .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                        const SizedBox(height: 24),
                        Text(
                              roomName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: AppTypography.primaryFont,
                                fontFamilyFallback: AppTypography.fallbackFonts,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 120.ms, duration: 300.ms)
                            .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                        const SizedBox(height: 8),
                        Text(
                              _categoryLabel(category),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 150.ms, duration: 260.ms)
                            .slideY(begin: 0.08, curve: Curves.easeOutCubic),
                        const SizedBox(height: 32),
                        _CodeCard(
                              code: roomId,
                              onCopy: () async {
                                final inviteLink = _buildRoomInviteLink(roomId);
                                await Clipboard.setData(
                                  ClipboardData(text: inviteLink),
                                );
                                HapticFeedback.lightImpact();
                                if (context.mounted) {
                                  _showThemedFloatingSnackBar(
                                    ScaffoldMessenger.of(context),
                                    'Invite link copied',
                                  );
                                }
                              },
                            )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 300.ms)
                            .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                        const SizedBox(height: 24),
                        _ShareRow(
                              roomCode: roomId,
                              inviteLink: _buildRoomInviteLink(roomId),
                              roomName: roomName,
                            )
                            .animate()
                            .fadeIn(delay: 260.ms, duration: 300.ms)
                            .slideY(begin: 0.14, curve: Curves.easeOutCubic),
                        const Spacer(),
                        AppButton.primary(
                              label: isHost
                                  ? 'Start Swiping →'
                                  : 'Waiting for host…',
                              onPressed: isHost
                                  ? () async {
                                      await ref
                                          .read(roomRepositoryProvider)
                                          .updateRoomStatus(
                                            roomId: roomId,
                                            status: 'active',
                                          );
                                      if (context.mounted) {
                                        context.go(AppRoutes.roomSwipe(roomId));
                                      }
                                    }
                                  : null,
                            )
                            .animate()
                            .fadeIn(delay: 320.ms, duration: 320.ms)
                            .slideY(begin: 0.16, curve: Curves.easeOutCubic),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (_, _) => const _MissingRoomView(),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.neonPink),
        ),
      ),
    );
  }

  static String _categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return '🍔 Restaurants';
      case 'activities':
        return '🎉 Activities';
      default:
        return '🎬 Movies';
    }
  }

  static String _buildRoomInviteLink(String roomId) {
    final sanitizedBase = _defaultInviteBaseUrl.endsWith('/')
        ? _defaultInviteBaseUrl.substring(0, _defaultInviteBaseUrl.length - 1)
        : _defaultInviteBaseUrl;
    return '$sanitizedBase/rooms/${roomId.toUpperCase()}';
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onSettings});
  final VoidCallback onBack;
  final VoidCallback onSettings;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _GlassIcon(icon: CupertinoIcons.back, onTap: onBack),
        _GlassIcon(icon: CupertinoIcons.settings, onTap: onSettings),
      ],
    );
  }
}

class _GlassIcon extends StatelessWidget {
  const _GlassIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Icon(icon, size: 22, color: Colors.white70),
      ),
    );
  }
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow({required this.memberCount});
  final int memberCount;
  @override
  Widget build(BuildContext context) {
    final avatarAssets = RoomPreview.generateAvatarAssetPaths(memberCount);
    final visibleCount = avatarAssets.length > 3 ? 3 : avatarAssets.length;
    final extra = (memberCount - visibleCount).clamp(0, 99);
    return SizedBox(
      width: 180,
      height: 54,
      child: Stack(
        children: [
          for (var index = 0; index < visibleCount; index += 1)
            _avatar(index * 42, avatarAssets[index]),
          if (extra > 0)
            Positioned(
              left: visibleCount * 42,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _avatar(double left, String asset) {
    return Positioned(
      left: left,
      child: Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.code, required this.onCopy});
  final String code;
  final VoidCallback onCopy;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0B2E), Color(0xFF12081F)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFF2FBF), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Room Code',
                style: TextStyle(
                  color: Color(0xFFD946EF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFF2FBF), Color(0xFFA855F7)],
                  ).createShader(bounds),
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: const Icon(
                  CupertinoIcons.doc_on_doc,
                  size: 28,
                  color: Color(0xFFFF2FBF),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.roomCode,
    required this.inviteLink,
    required this.roomName,
  });
  final String roomCode;
  final String inviteLink;
  final String roomName;

  String get _inviteText =>
      'Join my Picksy room "$roomName" ($roomCode): $inviteLink';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Share this code with your friends',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _social(
              label: 'WA',
              context: context,
              icon: FontAwesomeIcons.whatsapp,
              iconColor: const Color(0xFF25D366),
            ),
            const SizedBox(width: 16),
            _social(
              label: 'IG',
              context: context,
              icon: FontAwesomeIcons.instagram,
              iconColor: const Color(0xFFE1306C),
            ),
            const SizedBox(width: 16),
            _social(
              label: 'SC',
              context: context,
              icon: FontAwesomeIcons.snapchat,
              iconColor: const Color(0xFFFFFC00),
            ),
            const SizedBox(width: 16),
            _social(label: '⋯', context: context),
          ],
        ),
      ],
    );
  }

  Widget _social({
    required String label,
    required BuildContext context,
    FaIconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Gradient? backgroundGradient,
  }) {
    return GestureDetector(
      onTap: () async {
        final messenger = ScaffoldMessenger.of(context);

        Future<void> fallbackShare() async {
          await SharePlus.instance.share(
            ShareParams(text: _inviteText, subject: 'Join my Picksy room'),
          );
        }

        if (label == 'WA') {
          final waUri = Uri.parse(
            'https://wa.me/?text=${Uri.encodeComponent(_inviteText)}',
          );
          if (await canLaunchUrl(waUri)) {
            await launchUrl(waUri, mode: LaunchMode.externalApplication);
            return;
          }
          await fallbackShare();
          return;
        }

        if (label == 'IG') {
          final igUri = Uri.parse(
            'instagram://share?text=${Uri.encodeComponent(_inviteText)}',
          );
          if (await canLaunchUrl(igUri)) {
            await launchUrl(igUri, mode: LaunchMode.externalApplication);
            return;
          }
          await fallbackShare();
          _showThemedFloatingSnackBar(
            messenger,
            'Instagram share not available. Opened share sheet.',
          );
          return;
        }

        if (label == 'SC') {
          final snapUri = Uri.parse(
            'snapchat://creativeKitWeb/camera?caption=${Uri.encodeComponent(_inviteText)}',
          );
          if (await canLaunchUrl(snapUri)) {
            await launchUrl(snapUri, mode: LaunchMode.externalApplication);
            return;
          }
          await fallbackShare();
          _showThemedFloatingSnackBar(
            messenger,
            'Snapchat share not available. Opened share sheet.',
          );
          return;
        }

        await fallbackShare();
      },
      child: Container(
        width: 58,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.05),
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: icon == null
            ? Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              )
            : FaIcon(icon, color: iconColor ?? Colors.white, size: 36),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.align, required this.color});
  final Alignment align;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 120),
          ],
        ),
      ),
    );
  }
}

class _MissingRoomView extends StatelessWidget {
  const _MissingRoomView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppButton.secondary(
          label: 'Back to Rooms',
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
    );
  }
}

void _showThemedFloatingSnackBar(
  ScaffoldMessengerState messenger,
  String message,
) {
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: AppTypography.primaryFont,
          fontFamilyFallback: AppTypography.fallbackFonts,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      backgroundColor: const Color(0xFF171D2D),
      elevation: 10,
      duration: const Duration(milliseconds: 1600),
    ),
  );
}
