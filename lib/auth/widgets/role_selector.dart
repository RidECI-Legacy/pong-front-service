import 'package:flutter/material.dart';

import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

/// The two ways to join RidECI. Chosen in step 1 of the register wizard —
/// picking "conductor" grows the wizard by an extra "Vehículo" step, which
/// is how the passenger/driver registration paths diverge.
enum RideRole { pasajero, conductor }

extension RideRoleX on RideRole {
  String get label => this == RideRole.pasajero ? 'Pasajero' : 'Conductor';
  String get description => this == RideRole.pasajero
      ? 'Busco viajes y comparto ruta con conductores verificados.'
      : 'Ofrezco cupos en mi vehículo a la comunidad ECI.';
  IconData get icon => this == RideRole.pasajero ? Icons.person_rounded : Icons.directions_car_filled_rounded;
}

/// Large two-card role picker replacing a plain dropdown — the choice here
/// materially changes the rest of the form, so it earns a bigger, more
/// deliberate control with its own selected/glow state.
class RoleSelector extends StatelessWidget {
  final RideRole? value;
  final ValueChanged<RideRole> onChanged;

  const RoleSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 360;
      final cards = [
        _RoleCard(role: RideRole.pasajero, selected: value == RideRole.pasajero, onTap: () => onChanged(RideRole.pasajero)),
        _RoleCard(role: RideRole.conductor, selected: value == RideRole.conductor, onTap: () => onChanged(RideRole.conductor)),
      ];
      if (isNarrow) {
        return Column(
          children: [
            cards[0],
            const SizedBox(height: 10),
            cards[1],
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
        ],
      );
    });
  }
}

class _RoleCard extends StatefulWidget {
  final RideRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({required this.role, required this.selected, required this.onTap});

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AuthColors.primary.withValues(alpha: 0.12) : Colors.white.withValues(alpha: _hover ? 0.05 : 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AuthColors.primary : AuthColors.glassBorder, width: selected ? 1.5 : 1),
            boxShadow: selected
                ? [BoxShadow(color: AuthColors.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 6))]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected ? AuthColors.primary : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.role.icon, size: 19, color: selected ? Colors.white : AuthColors.textSecondary),
                  ),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: selected ? 1 : 0,
                    curve: Curves.easeOutBack,
                    child: const Icon(Icons.check_circle_rounded, size: 20, color: AuthColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.role.label, style: LandingType.cardTitle(size: 14.5, color: AuthColors.textPrimary)),
              const SizedBox(height: 4),
              Text(widget.role.description, style: LandingType.body(size: 11, color: AuthColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
