import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/auth_field.dart';
import '../register_data.dart';

class StepAcademic extends StatelessWidget {
  final RegisterData data;
  final Map<String, String> errors;
  final TextEditingController studentIdCtrl;
  final VoidCallback onChanged;

  const StepAcademic({
    super.key,
    required this.data,
    required this.errors,
    required this.studentIdCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthTextField(
          label: 'Carné estudiantil / ID ECI',
          hint: '2021-123456',
          helperText: 'El número aparece en tu carné físico de la ECI',
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
          controller: studentIdCtrl,
          errorText: errors['studentId'],
          onChanged: (v) {
            data.studentId = v;
            onChanged();
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthDropdownField<String>(
                label: 'Programa / Carrera',
                hint: 'Selecciona...',
                value: data.program,
                options: RegisterOptions.programs,
                labelOf: (v) => v,
                errorText: errors['program'],
                onChanged: (v) {
                  data.program = v;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AuthDropdownField<String>(
                label: 'Semestre actual',
                hint: 'Selecciona...',
                value: data.semester,
                options: RegisterOptions.semesters,
                labelOf: (v) => v,
                errorText: errors['semester'],
                onChanged: (v) {
                  data.semester = v;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuthDropdownField<String>(
          label: 'Tipo de vinculación',
          hint: 'Selecciona...',
          value: data.affiliation,
          options: RegisterOptions.affiliations,
          labelOf: (v) => v,
          errorText: errors['affiliation'],
          onChanged: (v) {
            data.affiliation = v;
            onChanged();
          },
        ),
        const SizedBox(height: 16),
        AuthDropdownField<String>(
          label: 'Zona de residencia habitual',
          hint: 'Selecciona una localidad...',
          required: false,
          helperText: 'Nos ayuda a encontrar viajes cercanos a tu casa',
          value: data.zone,
          options: RegisterOptions.zones,
          labelOf: (v) => v,
          onChanged: (v) {
            data.zone = v;
            onChanged();
          },
        ),
      ],
    );
  }
}
