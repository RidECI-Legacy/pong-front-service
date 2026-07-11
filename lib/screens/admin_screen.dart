import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/depth_card.dart';
import '../widgets/trip_list_item.dart';

enum _AdminTab { validations, trips, reports, stats, users, institutional }

const _adminNavItems = [
  SidebarItem(icon: Icons.verified_user_outlined, label: 'Validaciones'),
  SidebarItem(icon: Icons.alt_route_outlined, label: 'Viajes activos'),
  SidebarItem(icon: Icons.flag_outlined, label: 'Reportes de seguridad'),
  SidebarItem(icon: Icons.query_stats_outlined, label: 'Estadísticas y sostenibilidad'),
  SidebarItem(icon: Icons.groups_outlined, label: 'Usuarios'),
  SidebarItem(icon: Icons.summarize_outlined, label: 'Reportes institucionales'),
];

const _adminSubtitles = {
  _AdminTab.validations: 'Aprueba o suspende solicitudes de rol',
  _AdminTab.trips: 'Monitorea los viajes activos de la comunidad',
  _AdminTab.reports: 'Gestiona incidentes de seguridad y comportamiento',
  _AdminTab.stats: 'Impacto ambiental y participación de la comunidad',
  _AdminTab.users: 'Directorio de perfiles registrados en RidECI',
  _AdminTab.institutional: 'Horarios permitidos y exportación de reportes',
};

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _AdminTab _tab = _AdminTab.validations;
  late List<ValidationRequest> _requests;
  late List<SecurityReport> _reports;

  @override
  void initState() {
    super.initState();
    _requests = List.of(MockData.validationRequests);
    _reports = List.of(MockData.securityReports);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      roleIcon: Icons.shield_outlined,
      roleLabel: 'Administrador',
      title: 'Panel de administración',
      subtitle: _adminSubtitles[_tab]!,
      avatarInitials: 'AD',
      navItems: _adminNavItems,
      navSelectedIndex: _AdminTab.values.indexOf(_tab),
      onNavSelect: (i) => setState(() => _tab = _AdminTab.values[i]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_tab == _AdminTab.validations) _ValidationsTable(requests: _requests, onRemove: _remove),
          if (_tab == _AdminTab.trips) const _ActiveTripsList(),
          if (_tab == _AdminTab.reports) _ReportsList(reports: _reports, onStatusChange: _updateReportStatus),
          if (_tab == _AdminTab.stats) const _StatsGrid(),
          if (_tab == _AdminTab.users) const _UsersDirectory(),
          if (_tab == _AdminTab.institutional) const _InstitutionalPanel(),
        ],
      ),
    );
  }

  void _remove(ValidationRequest request) {
    setState(() => _requests.remove(request));
  }

  void _updateReportStatus(SecurityReport report, String status) {
    setState(() => report.status = status);
  }
}

class _ValidationsTable extends StatelessWidget {
  final List<ValidationRequest> requests;
  final ValueChanged<ValidationRequest> onRemove;

  const _ValidationsTable({required this.requests, required this.onRemove});

  static Map<String, Color> get _roleColors => {
    'Conductor': AppColors.violetDeep,
    'Pasajero': AppColors.mintDeep,
    'Acompañante': AppColors.amberDeep,
  };

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const _EmptyState(text: 'No hay solicitudes de validación pendientes.');
    }

    return LiftedCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 720;
        if (isMobile) {
          return Column(
            children: [
              for (int i = 0; i < requests.length; i++) ...[
                _ValidationMobileRow(request: requests[i], onRemove: onRemove, roleColors: _roleColors),
                if (i != requests.length - 1) const Divider(height: 1),
              ],
            ],
          );
        }
        return Column(
          children: [
            const _HeaderRow(),
            const Divider(height: 1),
            for (int i = 0; i < requests.length; i++) ...[
              _ValidationRow(request: requests[i], onRemove: onRemove, roleColors: _roleColors),
              if (i != requests.length - 1) const Divider(height: 1),
            ],
          ],
        );
      }),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('NOMBRE', style: style)),
          Expanded(flex: 2, child: Text('ROL SOLICITADO', style: style)),
          Expanded(flex: 3, child: Text('CORREO', style: style)),
          Expanded(flex: 2, child: Text('CÉDULA', style: style)),
          Expanded(flex: 3, child: Text('ACCIONES', style: style)),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  final Map<String, Color> roleColors;
  const _RoleBadge({required this.role, required this.roleColors});

  @override
  Widget build(BuildContext context) {
    final color = roleColors[role] ?? AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
      child: Text(role, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onSuspend;
  const _ActionButtons({required this.onApprove, required this.onSuspend});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: onApprove,
          icon: const Icon(Icons.check, size: 15),
          label: const Text('Aprobar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mint,
            foregroundColor: AppColors.deepGreenDarker,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onSuspend,
          icon: const Icon(Icons.block, size: 15),
          label: const Text('Suspender', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coral.withValues(alpha: 0.12),
            foregroundColor: AppColors.coralDeep,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  final ValidationRequest request;
  final ValueChanged<ValidationRequest> onRemove;
  final Map<String, Color> roleColors;

  const _ValidationRow({required this.request, required this.onRemove, required this.roleColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(request.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
          Expanded(flex: 2, child: _RoleBadge(role: request.requestedRole, roleColors: roleColors)),
          Expanded(flex: 3, child: Text(request.email, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(request.maskedId, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted))),
          Expanded(
            flex: 3,
            child: _ActionButtons(onApprove: () => onRemove(request), onSuspend: () => onRemove(request)),
          ),
        ],
      ),
    );
  }
}

class _ValidationMobileRow extends StatelessWidget {
  final ValidationRequest request;
  final ValueChanged<ValidationRequest> onRemove;
  final Map<String, Color> roleColors;

  const _ValidationMobileRow({required this.request, required this.onRemove, required this.roleColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _RoleBadge(role: request.requestedRole, roleColors: roleColors),
            ],
          ),
          const SizedBox(height: 6),
          Text(request.email, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          Text('Cédula: ${request.maskedId}', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          _ActionButtons(onApprove: () => onRemove(request), onSuspend: () => onRemove(request)),
        ],
      ),
    );
  }
}

class _ActiveTripsList extends StatelessWidget {
  const _ActiveTripsList();

  static Map<String, Color> get _statusColors => {
    'En curso': AppColors.mintDeep,
    'Por iniciar': AppColors.amberDeep,
  };

  static const _statusIcons = {
    'En curso': Icons.play_circle_outline,
    'Por iniciar': Icons.schedule,
  };

  @override
  Widget build(BuildContext context) {
    final trips = MockData.activeAdminTrips;
    if (trips.isEmpty) {
      return const _EmptyState(text: 'No hay viajes activos en este momento.');
    }
    return LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VIAJES EN CURSO', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              Text('${trips.length} activos', style: TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
            ],
          ),
          const Divider(height: 24),
          for (int i = 0; i < trips.length; i++) ...[
            TripListItem(
              name: trips[i].driverName,
              subtitle: '${trips[i].route} · ${trips[i].time}',
              amountLabel: '${trips[i].seatsFilled}/${trips[i].seatsTotal} cupos',
              status: trips[i].status,
              statusColor: _statusColors[trips[i].status] ?? AppColors.textMuted,
              statusIcon: _statusIcons[trips[i].status],
              avatarColor: AppColors.blueAccent,
            ),
            if (i != trips.length - 1) const Divider(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ReportsList extends StatelessWidget {
  final List<SecurityReport> reports;
  final void Function(SecurityReport report, String status) onStatusChange;

  const _ReportsList({required this.reports, required this.onStatusChange});

  static Map<String, Color> get _typeColors => {
    'Comportamiento': AppColors.amberDeep,
    'Ausencia': AppColors.violetDeep,
    'Seguridad': AppColors.coralDeep,
  };

  static Map<String, Color> get _statusColors => {
    'Pendiente': AppColors.coralDeep,
    'En revisión': AppColors.amberDeep,
    'Resuelto': AppColors.mintDeep,
  };

  static const _statusIcons = {
    'Pendiente': Icons.error_outline,
    'En revisión': Icons.hourglass_empty,
    'Resuelto': Icons.check_circle_outline,
  };

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const _EmptyState(text: 'No hay reportes de seguridad registrados.');
    }
    return LiftedCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < reports.length; i++) ...[
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(reports[i].reportedUser, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                            const SizedBox(width: 8),
                            _RoleBadge(role: reports[i].type, roleColors: _typeColors),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(reports[i].description, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.4)),
                        const SizedBox(height: 6),
                        Text(reports[i].date, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: reports[i].status,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(10),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _statusColors[reports[i].status] ?? AppColors.textMuted,
                    ),
                    items: [
                      for (final status in const ['Pendiente', 'En revisión', 'Resuelto'])
                        DropdownMenuItem(
                          value: status,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_statusIcons[status], size: 14, color: _statusColors[status]),
                              const SizedBox(width: 6),
                              Text(status),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) onStatusChange(reports[i], value);
                    },
                  ),
                ],
              ),
            ),
            if (i != reports.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return LiftedCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(child: Text(text, style: TextStyle(color: AppColors.textMuted))),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  static List<(String, double, Color, Color)> get _roleBreakdown => [
    ('Pasajeros', 0.52, AppColors.mint, AppColors.mintDeep),
    ('Conductores', 0.31, AppColors.blueAccent, AppColors.blueAccentDark),
    ('Acompañantes', 0.17, AppColors.amber, AppColors.amberDeep),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          int columns = 4;
          if (width < 860) columns = 2;
          if (width < 480) columns = 1;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final stat in MockData.impactStatsFooter)
                SizedBox(
                  width: (width - (columns - 1) * 16) / columns,
                  child: DepthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stat.value, style: TextStyle(color: AppColors.mintDeep, fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(stat.label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 860;
          final breakdown = DepthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PARTICIPACIÓN POR ROL', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                const SizedBox(height: 18),
                for (final r in _roleBreakdown) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r.$1, style: TextStyle(color: AppColors.textDark, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      Text('${(r.$2 * 100).round()}%', style: TextStyle(color: r.$4, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: r.$2,
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(r.$3),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          );

          final distintivos = LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DISTINTIVOS OTORGADOS', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                const SizedBox(height: 16),
                _DistintivoRow(icon: Icons.emoji_events_outlined, label: 'Conductor confiable', count: 64, color: AppColors.mintDeep),
                const SizedBox(height: 12),
                _DistintivoRow(icon: Icons.favorite_outline, label: 'Amigable', count: 128, color: AppColors.coralDeep),
                const SizedBox(height: 12),
                _DistintivoRow(icon: Icons.timeline_outlined, label: 'Pasajero frecuente', count: 91, color: AppColors.blueAccentDark),
              ],
            ),
          );

          if (isMobile) {
            return Column(children: [breakdown, const SizedBox(height: 16), distintivos]);
          }
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: breakdown),
                const SizedBox(width: 16),
                Expanded(child: distintivos),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _DistintivoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _DistintivoRow({required this.icon, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textDark))),
        Text('$count', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

// --- Usuarios: directorio institucional (Módulo 6 / 7) ---

class _UsersDirectory extends StatefulWidget {
  const _UsersDirectory();

  @override
  State<_UsersDirectory> createState() => _UsersDirectoryState();
}

class _UsersDirectoryState extends State<_UsersDirectory> {
  String _query = '';

  static Map<String, Color> get _statusColors => {
    'Activo': AppColors.mintDeep,
    'Suspendido': AppColors.coralDeep,
    'Pendiente': AppColors.amberDeep,
  };

  static const _statusIcons = {
    'Activo': Icons.check_circle_outline,
    'Suspendido': Icons.block,
    'Pendiente': Icons.hourglass_empty,
  };

  static Map<String, Color> get _roleColors => {
    'Conductor': AppColors.violetDeep,
    'Pasajero': AppColors.mintDeep,
    'Acompañante': AppColors.amberDeep,
  };

  @override
  Widget build(BuildContext context) {
    final users = MockData.userDirectory
        .where((u) => u.name.toLowerCase().contains(_query.toLowerCase()) || u.email.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiftedCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o correo institucional…',
              border: InputBorder.none,
              icon: Icon(Icons.search, size: 18, color: AppColors.textMuted),
            ),
          ),
        ),
        const SizedBox(height: 16),
        LiftedCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < users.length; i++) ...[
                _UserRow(user: users[i], statusColors: _statusColors, statusIcons: _statusIcons, roleColors: _roleColors),
                if (i != users.length - 1) const Divider(height: 1),
              ],
              if (users.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No se encontraron usuarios.', style: TextStyle(color: AppColors.textMuted))),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserRow extends StatelessWidget {
  final UserDirectoryEntry user;
  final Map<String, Color> statusColors;
  final Map<String, IconData> statusIcons;
  final Map<String, Color> roleColors;

  const _UserRow({required this.user, required this.statusColors, required this.statusIcons, required this.roleColors});

  @override
  Widget build(BuildContext context) {
    final statusColor = statusColors[user.status] ?? AppColors.textMuted;
    final roleColor = roleColors[user.role] ?? AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: roleColor.withValues(alpha: 0.16),
            child: Text(_userInitials(user.name), style: TextStyle(color: roleColor, fontWeight: FontWeight.w800, fontSize: 11)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                Text(user.email, style: TextStyle(fontSize: 11.5, color: AppColors.textMuted), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                child: Text(user.role, style: TextStyle(color: roleColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: user.trips == 0
                ? Text('—', style: TextStyle(color: AppColors.textMuted, fontSize: 12.5))
                : Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.amber),
                      const SizedBox(width: 3),
                      Text('${user.rating} · ${user.trips} viajes', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcons[user.status], size: 11, color: statusColor),
                const SizedBox(width: 4),
                Text(user.status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _userInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
}

// --- Reportes institucionales: horarios y exportación (Módulo 7) ---

class _InstitutionalPanel extends StatefulWidget {
  const _InstitutionalPanel();

  @override
  State<_InstitutionalPanel> createState() => _InstitutionalPanelState();
}

class _InstitutionalPanelState extends State<_InstitutionalPanel> {
  String _format = 'PDF';
  String _range = 'Semanal';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final schedule = LiftedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HORARIOS PERMITIDOS PARA PUBLICAR VIAJES', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            const SizedBox(height: 16),
            const _ScheduleRow(days: 'Lunes a viernes', hours: '4:00 am – 9:00 pm'),
            const _ScheduleRow(days: 'Sábados', hours: '4:00 am – 6:00 pm'),
            const _ScheduleRow(days: 'Domingos', hours: 'No disponible'),
          ],
        ),
      );

      final export = LiftedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXPORTAR REPORTES', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            const SizedBox(height: 16),
            Text('Periodo', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in const ['Semanal', 'Mensual', 'Semestral'])
                  ChoiceChip(
                    label: Text(r, style: const TextStyle(fontSize: 12)),
                    selected: _range == r,
                    selectedColor: AppColors.mint.withValues(alpha: 0.18),
                    labelStyle: TextStyle(color: _range == r ? AppColors.mintDeep : AppColors.textMuted, fontWeight: FontWeight.w600),
                    onSelected: (_) => setState(() => _range = r),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Formato', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in const ['PDF', 'Excel'])
                  ChoiceChip(
                    label: Text(f, style: const TextStyle(fontSize: 12)),
                    selected: _format == f,
                    selectedColor: AppColors.mint.withValues(alpha: 0.18),
                    labelStyle: TextStyle(color: _format == f ? AppColors.mintDeep : AppColors.textMuted, fontWeight: FontWeight.w600),
                    onSelected: (_) => setState(() => _format = f),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.deepGreenDarker,
                      content: Text('Reporte $_range generado en $_format.', style: const TextStyle(color: Colors.white, fontSize: 12.5)),
                    ),
                  );
                },
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Generar y descargar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mint,
                  foregroundColor: AppColors.deepGreenDarker,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );

      if (isMobile) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [schedule, const SizedBox(height: 16), export]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: schedule),
          const SizedBox(width: 16),
          Expanded(child: export),
        ],
      );
    });
  }
}

class _ScheduleRow extends StatelessWidget {
  final String days;
  final String hours;
  const _ScheduleRow({required this.days, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(days, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          Text(hours, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
