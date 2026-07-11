import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/auth_colors.dart';

/// Small glass-framed illustration shown next to the branding copy on the
/// left panel of the register wizard / password recovery. Fills the wide
/// empty column next to the headline with a piece of concrete visual
/// content that changes per step, instead of leaving it blank.
class StepIllustration extends StatelessWidget {
  final String asset;

  const StepIllustration({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 168,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AuthColors.glassFill,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AuthColors.glassBorder),
        boxShadow: [
          BoxShadow(
              color: AuthColors.primary.withValues(alpha: 0.18),
              blurRadius: 40,
              offset: const Offset(0, 20)),
        ],
      ),
      child: SvgPicture.asset(asset, fit: BoxFit.contain),
    );
  }
}
