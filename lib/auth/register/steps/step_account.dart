import 'package:flutter/material.dart';

import '../../widgets/auth_field.dart';
import '../../widgets/password_strength_bar.dart';
import '../register_data.dart';

class StepAccount extends StatefulWidget {
  final RegisterData data;
  final Map<String, String> errors;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final VoidCallback onChanged;

  const StepAccount({
    super.key,
    required this.data,
    required this.errors,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.onChanged,
  });

  @override
  State<StepAccount> createState() => _StepAccountState();
}

class _StepAccountState extends State<StepAccount> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final errors = widget.errors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthTextField(
          label: 'Contraseña',
          hint: 'Mínimo 8 caracteres',
          obscureText: _obscurePassword,
          controller: widget.passwordCtrl,
          errorText: errors['password'],
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          onChanged: (v) {
            data.password = v;
            widget.onChanged();
          },
        ),
        PasswordStrengthBar(password: data.password),
        const SizedBox(height: 16),
        AuthTextField(
          label: 'Confirmar contraseña',
          hint: 'Repite tu contraseña',
          obscureText: _obscureConfirm,
          controller: widget.confirmCtrl,
          errorText: errors['confirmPassword'],
          suffixIcon: IconButton(
            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          onChanged: (v) {
            data.confirmPassword = v;
            widget.onChanged();
          },
        ),
      ],
    );
  }
}
