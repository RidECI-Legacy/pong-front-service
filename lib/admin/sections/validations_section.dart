import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models.dart';
import '../../passenger/components/empty_state.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/passenger_actions.dart';
import '../components/validation_request_card.dart';

/// SECTION "Validaciones": approve or suspend pending role requests.
class ValidationsSection extends StatelessWidget {
  final List<ValidationRequest> requests;
  final ValueChanged<ValidationRequest> onApprove;
  final ValueChanged<ValidationRequest> onSuspend;

  const ValidationsSection({super.key, required this.requests, required this.onApprove, required this.onSuspend});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: Icons.verified_user_rounded,
          title: 'Validaciones',
          subtitle: requests.isEmpty ? 'No hay solicitudes pendientes' : '${requests.length} solicitud${requests.length == 1 ? '' : 'es'} de rol por revisar',
        ),
        const SizedBox(height: 20),
        if (requests.isEmpty)
          const EmptyState(
            icon: Icons.verified_user_rounded,
            title: 'Todo al día',
            description: 'No hay solicitudes de validación pendientes en este momento.',
          )
        else
          for (var i = 0; i < requests.length; i++) ...[
            ValidationRequestCard(
              request: requests[i],
              onApprove: () {
                onApprove(requests[i]);
                showActionSnack(context, 'Solicitud de ${requests[i].name} aprobada.');
              },
              onSuspend: () {
                onSuspend(requests[i]);
                showActionSnack(context, 'Solicitud de ${requests[i].name} suspendida.', icon: Icons.block_rounded);
              },
            ).animate(delay: (40 * i).ms).fadeIn(duration: 280.ms).slideY(begin: 0.05, curve: Curves.easeOutCubic),
            if (i != requests.length - 1) const SizedBox(height: 12),
          ],
      ],
    );
  }
}
