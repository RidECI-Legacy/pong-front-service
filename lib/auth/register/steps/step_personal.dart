import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../landing/theme/typography.dart';
import '../../theme/auth_colors.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/role_selector.dart';
import '../register_data.dart';

class StepPersonal extends StatelessWidget {
  final RegisterData data;
  final Map<String, String> errors;
  final TextEditingController fullNameCtrl;
  final TextEditingController cedulaCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final VoidCallback onChanged;

  const StepPersonal({
    super.key,
    required this.data,
    required this.errors,
    required this.fullNameCtrl,
    required this.cedulaCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthTextField(
          label: 'Nombre completo',
          hint: 'Ej: Juan Pablo García Rodríguez',
          controller: fullNameCtrl,
          errorText: errors['fullName'],
          onChanged: (v) {
            data.fullName = v;
            onChanged();
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthTextField(
                label: 'Número de cédula (CC)',
                hint: '1020304050',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: cedulaCtrl,
                errorText: errors['cedula'],
                onChanged: (v) {
                  data.cedula = v;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AuthTextField(
                label: 'Teléfono celular',
                hint: '3001234567',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: phoneCtrl,
                errorText: errors['phone'],
                onChanged: (v) {
                  data.phone = v;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuthTextField(
          label: 'Correo institucional',
          hint: 'nombre@mail.escuelaing.edu.co',
          keyboardType: TextInputType.emailAddress,
          helperText: 'Solo se permiten correos @escuelaing.edu.co o @mail.escuelaing.edu.co',
          controller: emailCtrl,
          errorText: errors['email'],
          onChanged: (v) {
            data.email = v;
            onChanged();
          },
        ),
        const SizedBox(height: 18),
        Text(
          'ROL EN RIDECI *',
          style: LandingType.body(size: 10.5, color: AuthColors.textMuted).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8),
        ),
        const SizedBox(height: 8),
        RoleSelector(
          value: data.role,
          onChanged: (r) {
            data.role = r;
            onChanged();
          },
        ),
        if (errors['role'] != null) ...[
          const SizedBox(height: 6),
          Text(errors['role']!, style: const TextStyle(color: AuthColors.danger, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('Podrás cambiar de rol más adelante desde tu perfil.', style: LandingType.body(size: 11, color: AuthColors.textMuted)),
        ),
      ],
    );
  }
}
