import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/empty_state.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/search_field.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/theme.dart';
import '../components/user_directory_row.dart';

/// SECTION "Usuarios": the searchable institutional directory of every
/// registered profile.
class UsersSection extends StatefulWidget {
  const UsersSection({super.key});

  @override
  State<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final users = MockData.userDirectory.where((u) => u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(icon: Icons.groups_rounded, title: 'Usuarios', subtitle: '${MockData.userDirectory.length} perfiles registrados en RidECI', accent: LandingColors.accent),
        const SizedBox(height: 20),
        SearchField(label: 'Buscar', icon: Icons.search_rounded, hint: 'Nombre o correo institucional…', onChanged: (v) => setState(() => _query = v)),
        const SizedBox(height: 20),
        if (users.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados',
            description: 'Ningún usuario coincide con "$_query".',
            actionLabel: 'Limpiar búsqueda',
            onAction: () => setState(() => _query = ''),
          )
        else
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                for (var i = 0; i < users.length; i++) ...[
                  UserDirectoryRow(user: users[i]),
                  if (i != users.length - 1) Divider(height: 1, color: LandingColors.glassBorder),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
