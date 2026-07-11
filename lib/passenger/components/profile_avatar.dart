import 'package:flutter/material.dart';

import '../theme.dart';

/// Circular initials avatar with an optional online dot and ring, used for
/// the passenger, drivers and any "person" reference across the dashboard.
class ProfileAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color background;
  final bool online;
  final bool ring;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.background = LandingColors.primary,
    this.online = false,
    this.ring = false,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [background, background.withValues(alpha: 0.7)]),
        border: ring ? Border.all(color: Colors.white.withValues(alpha: 0.18), width: 2) : null,
      ),
      child: Text(
        _initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.36),
      ),
    );

    if (!online) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: size * 0.28,
            height: size * 0.28,
            decoration: BoxDecoration(
              color: LandingColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: LandingColors.bgSurface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
