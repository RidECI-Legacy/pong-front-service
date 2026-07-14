import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../passenger/components/profile_avatar.dart';
import '../../passenger/theme.dart';
import 'colored_pill.dart';

/// One row of the institutional user directory: identity, role, rating +
/// trip count and account status.
class UserDirectoryRow extends StatelessWidget {
  final UserDirectoryEntry user;

  const UserDirectoryRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final roleColor = AdminPalette.roleColors[user.role] ?? LandingColors.textTertiary;
    final statusColor = AdminPalette.userStatusColors[user.status] ?? LandingColors.textTertiary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Row(
        children: [
          ProfileAvatar(name: user.name, size: 38, background: roleColor),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.name, style: LandingType.cardTitle(size: 13), overflow: TextOverflow.ellipsis),
                Text(user.email, style: LandingType.body(size: 11.5, color: LandingColors.textTertiary), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: ColoredPill(label: user.role, color: roleColor))),
          Expanded(
            flex: 2,
            child: user.trips == 0
                ? Text('—', style: LandingType.body(size: 12, color: LandingColors.textTertiary))
                : Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFBBF24)),
                      const SizedBox(width: 3),
                      Flexible(child: Text('${user.rating} · ${user.trips} viajes', style: LandingType.body(size: 11.5), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
          ),
          ColoredPill(label: user.status, color: statusColor, icon: AdminPalette.userStatusIcons[user.status]),
        ],
      ),
    );
  }
}
