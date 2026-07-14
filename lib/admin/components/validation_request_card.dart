import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/profile_avatar.dart';
import '../../passenger/theme.dart';
import 'colored_pill.dart';

/// One pending role-validation request: identity, requested role, masked
/// ID and approve/suspend actions. A card instead of a dense table row so
/// it stays legible and touch-friendly at any width.
class ValidationRequestCard extends StatelessWidget {
  final ValidationRequest request;
  final VoidCallback onApprove;
  final VoidCallback onSuspend;

  const ValidationRequestCard({super.key, required this.request, required this.onApprove, required this.onSuspend});

  @override
  Widget build(BuildContext context) {
    final roleColor = AdminPalette.roleColors[request.requestedRole] ?? LandingColors.textTertiary;
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;
        final identity = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(name: request.name, size: 42, background: roleColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(request.name, style: LandingType.cardTitle(size: 14), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      ColoredPill(label: request.requestedRole, color: roleColor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(request.email, style: LandingType.body(size: 12), overflow: TextOverflow.ellipsis),
                  Text('Cédula: ${request.maskedId}', style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
                ],
              ),
            ),
          ],
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(label: 'Suspender', icon: Icons.block_rounded, onTap: onSuspend),
            const SizedBox(width: 8),
            PrimaryButton(label: 'Aprobar', icon: Icons.check_rounded, onTap: onApprove, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
          ],
        );

        if (isNarrow) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [identity, const SizedBox(height: 14), actions]);
        }
        return Row(children: [Expanded(child: identity), const SizedBox(width: 14), actions]);
      }),
    );
  }
}
