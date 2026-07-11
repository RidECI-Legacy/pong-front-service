import 'package:flutter/material.dart';

import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

enum PasswordStrength { empty, weak, medium, strong }

PasswordStrength computePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.empty;
  var score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
  if (score <= 1) return PasswordStrength.weak;
  if (score <= 3) return PasswordStrength.medium;
  return PasswordStrength.strong;
}

/// Three-segment strength meter shown under the password field, matching
/// the "Seguridad de la contraseña … Media" indicator in the Mocks.
class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = computePasswordStrength(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    final filled = switch (strength) {
      PasswordStrength.empty => 0,
      PasswordStrength.weak => 1,
      PasswordStrength.medium => 2,
      PasswordStrength.strong => 3,
    };
    final color = switch (strength) {
      PasswordStrength.weak => AuthColors.danger,
      PasswordStrength.medium => AuthColors.warning,
      PasswordStrength.strong => AuthColors.success,
      PasswordStrength.empty => AuthColors.border,
    };
    final label = switch (strength) {
      PasswordStrength.weak => 'Débil',
      PasswordStrength.medium => 'Media',
      PasswordStrength.strong => 'Fuerte',
      PasswordStrength.empty => '',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seguridad de la contraseña', style: LandingType.body(size: 11, color: AuthColors.textMuted)),
              Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < filled ? color : AuthColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
