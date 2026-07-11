import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'profile_avatar.dart';

/// The 80px top bar: search, notification center, avatar + passenger
/// badge and a settings button. Gains a blurred background once the
/// content behind it scrolls, mirroring the landing navbar.
class PassengerTopBar extends StatefulWidget {
  final ScrollController scrollController;
  final RiderProfile rider;
  final int unreadNotifications;
  final VoidCallback onNotificationsTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;
  final ValueChanged<String>? onSearchChanged;

  const PassengerTopBar({
    super.key,
    required this.scrollController,
    required this.rider,
    required this.unreadNotifications,
    required this.onNotificationsTap,
    required this.onSettingsTap,
    required this.onProfileTap,
    this.onSearchChanged,
  });

  @override
  State<PassengerTopBar> createState() => _PassengerTopBarState();
}

class _PassengerTopBarState extends State<PassengerTopBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrolled = widget.scrollController.hasClients && widget.scrollController.offset > 8;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _scrolled ? 14 : 0, sigmaY: _scrolled ? 14 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: _scrolled ? LandingColors.bgDeepest.withValues(alpha: 0.72) : LandingColors.bgDeepest.withValues(alpha: 0.3),
            border: Border(bottom: BorderSide(color: _scrolled ? LandingColors.glassBorder : Colors.transparent)),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 640;
            return Row(
              children: [
                if (!isCompact)
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: _QuickSearchBar(onChanged: widget.onSearchChanged),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 16),
                GhostIconButton(icon: Icons.settings_outlined, tooltip: 'Configuración', onTap: widget.onSettingsTap),
                const SizedBox(width: 10),
                _NotificationButton(count: widget.unreadNotifications, onTap: widget.onNotificationsTap),
                const SizedBox(width: 14),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onProfileTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileAvatar(name: widget.rider.name, size: 38, online: true),
                        if (!isCompact) ...[
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.rider.name.split(' ').first, style: LandingType.cardTitle(size: 12.5)),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: LandingColors.success.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('Pasajero', style: TextStyle(color: LandingColors.success, fontSize: 9, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _QuickSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const _QuickSearchBar({this.onChanged});

  @override
  State<_QuickSearchBar> createState() => _QuickSearchBarState();
}

class _QuickSearchBarState extends State<_QuickSearchBar> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _focused ? LandingColors.accent.withValues(alpha: 0.55) : LandingColors.glassBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 17, color: _focused ? LandingColors.accent : LandingColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Buscar viajes, conductores…',
                hintStyle: const TextStyle(color: LandingColors.textTertiary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _NotificationButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GhostIconButton(icon: Icons.notifications_outlined, tooltip: 'Notificaciones', onTap: onTap),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: const BoxDecoration(color: LandingColors.danger, shape: BoxShape.circle),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
              ),
            ),
          ),
      ],
    );
  }
}
