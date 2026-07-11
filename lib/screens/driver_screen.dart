import 'package:flutter/material.dart';

import '../data/car_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/chat_dialog.dart';
import '../widgets/depth_card.dart';
import '../widgets/emergency_button.dart';
import '../widgets/report_dialog.dart';
import '../widgets/route_timeline.dart';
import '../widgets/trip_list_item.dart';
import '../widgets/vehicle_showcase.dart';

enum _DriverTab { home, createTrip, myTrips, vehicle, stats, security }

/// Consistent minimum height for sidebar cards
const _sidebarCardMinHeight = 140.0;

const _driverNavItems = [
  SidebarItem(icon: Icons.home_outlined, label: 'Inicio'),
  SidebarItem(icon: Icons.add_road_outlined, label: 'Crear viaje'),
  SidebarItem(icon: Icons.list_alt_outlined, label: 'Mis viajes'),
  SidebarItem(icon: Icons.directions_car_filled_outlined, label: 'Mi vehículo'),
  SidebarItem(icon: Icons.bar_chart_outlined, label: 'Estadísticas'),
  SidebarItem(icon: Icons.shield_outlined, label: 'Seguridad'),
];

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  _DriverTab _tab = _DriverTab.home;

  static const _titles = {
    _DriverTab.home: 'Hola, Camilo 🚗',
    _DriverTab.createTrip: 'Crear viaje',
    _DriverTab.myTrips: 'Mis viajes',
    _DriverTab.vehicle: 'Mi vehículo',
    _DriverTab.stats: 'Estadísticas y sostenibilidad',
    _DriverTab.security: 'Seguridad',
  };

  static const _subtitles = {
    _DriverTab.home: 'Conductor · Chevrolet Spark · 4 puestos',
    _DriverTab.createTrip: 'Publica un nuevo viaje para pasajeros',
    _DriverTab.myTrips: 'Viajes programados e historial',
    _DriverTab.vehicle: 'Datos del vehículo y licencia de conducción',
    _DriverTab.stats: 'Ganancias, calificación e impacto ambiental',
    _DriverTab.security: 'Reportes, chat y contacto de confianza',
  };

  @override
  Widget build(BuildContext context) {
    return AppShell(
      roleIcon: Icons.directions_car_outlined,
      roleLabel: 'Conductor',
      title: _titles[_tab]!,
      subtitle: _subtitles[_tab]!,
      avatarInitials: 'CR',
      navItems: _driverNavItems,
      navSelectedIndex: _DriverTab.values.indexOf(_tab),
      onNavSelect: (i) => setState(() => _tab = _DriverTab.values[i]),
      trailing: _tab == _DriverTab.home
          ? Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mint.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: AppColors.mintDeep),
                  const SizedBox(width: 8),
                  Text('Disponible',
                      style: TextStyle(
                          color: AppColors.mintDeep,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5)),
                ],
              ),
            )
          : null,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_tab) {
      case _DriverTab.home:
        return LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < kMobileBreakpoint;
          const left = _CurrentTripPanel();
          final right = _StatsAndHistoryColumn(compact: true);
          final quickActions = _QuickActionsRow(
            actions: [
              (
                Icons.add_road_outlined,
                'Crear viaje',
                'Publica un nuevo trayecto',
                () => setState(() => _tab = _DriverTab.createTrip)
              ),
              (
                Icons.directions_car_filled_outlined,
                'Mi vehículo',
                'Datos y documentos del carro',
                () => setState(() => _tab = _DriverTab.vehicle)
              ),
              (
                Icons.shield_outlined,
                'Seguridad',
                'Reportes y contacto de confianza',
                () => setState(() => _tab = _DriverTab.security)
              ),
            ],
          );

          if (isMobile) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  left,
                  const SizedBox(height: 24),
                  right,
                  const SizedBox(height: 24),
                  quickActions
                ]);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 7, child: left),
                  const SizedBox(width: 24),
                  SizedBox(width: 360, child: right),
                ],
              ),
              const SizedBox(height: 24),
              quickActions,
            ],
          );
        });
      case _DriverTab.createTrip:
        return const _CreateTripFullPanel();
      case _DriverTab.myTrips:
        return const _MyTripsPanel();
      case _DriverTab.vehicle:
        return const _VehiclePanel();
      case _DriverTab.stats:
        return const _StatsAndHistoryColumn(compact: false);
      case _DriverTab.security:
        return const _DriverSecurityPanel();
    }
  }
}

class _CurrentTripPanel extends StatelessWidget {
  const _CurrentTripPanel();

  @override
  Widget build(BuildContext context) {
    return DepthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VIAJE EN CURSO',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              Row(
                children: [
                  const EmergencyButton(),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule,
                            size: 12, color: AppColors.amberDeep),
                        const SizedBox(width: 5),
                        Text('7:00 AM',
                            style: TextStyle(
                                color: AppColors.amberDeep,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 520;
            final vehicle = const VehicleShowcase(
              brandModel: 'Chevrolet Spark',
              rating: 4.8,
              carColor: CarColor.gray,
              specs: [
                (Icons.confirmation_number_outlined, 'Placa ABC-123'),
                (Icons.event_seat_outlined, '3 cupos disponibles'),
              ],
            );
            final info = const _TripQuickInfo();

            if (isNarrow) {
              return Column(children: [
                SizedBox(width: double.infinity, child: vehicle),
                const SizedBox(height: 16),
                info
              ]);
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 190, child: vehicle),
                  const SizedBox(width: 16),
                  Expanded(child: info),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 640;
            final mapBlock = Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: Text('[ mapa de ruta y paradas ]',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            );
            final timeline = Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const RouteTimeline(
                stops: [
                  RouteStop(
                      label: 'Origen',
                      detail: 'Portal 80, 7:00 AM',
                      dotColor: AppColors.mint),
                  RouteStop(
                      label: 'Parada',
                      detail: 'Calle 80 con 68',
                      dotColor: AppColors.amber),
                  RouteStop(
                      label: 'Destino',
                      detail: 'Escuela Ing. Julio Garavito',
                      dotColor: AppColors.coral),
                ],
              ),
            );

            if (isNarrow) {
              return Column(
                  children: [mapBlock, const SizedBox(height: 12), timeline]);
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 6, child: mapBlock),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: timeline),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Text('PASAJEROS CONFIRMADOS',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (int i = 0;
                    i < MockData.confirmedPassengers.length;
                    i++) ...[
                  _PassengerRow(passenger: MockData.confirmedPassengers[i]),
                  if (i != MockData.confirmedPassengers.length - 1)
                    Divider(height: 1, color: AppColors.border),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripQuickInfo extends StatelessWidget {
  const _TripQuickInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _MiniInfo(label: 'Duración', value: '18 min')),
              Expanded(child: _MiniInfo(label: 'Ganancia', value: '\$13.500')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MiniInfo(label: 'Distancia', value: '9.2 km')),
              Expanded(child: _MiniInfo(label: 'Pasajeros', value: '2/3')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showChatDialog(context, withName: 'Laura Gómez'),
              icon: Icon(Icons.chat_bubble_outline,
                  size: 15, color: AppColors.textMuted),
              label: Text('Chatear con pasajeros',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.textMuted)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String value;
  const _MiniInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 14)),
      ],
    );
  }
}

class _PassengerRow extends StatelessWidget {
  final ConfirmedPassenger passenger;
  const _PassengerRow({required this.passenger});

  @override
  Widget build(BuildContext context) {
    final pending = passenger.status == 'Pendiente';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.border,
            child: Text(_initials(passenger.name),
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(passenger.name,
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(passenger.pickup,
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: pending
                  ? AppColors.amber.withValues(alpha: 0.18)
                  : AppColors.mint.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(pending ? Icons.hourglass_empty : Icons.check_circle,
                    size: 11,
                    color: pending ? AppColors.amberDeep : AppColors.mintDeep),
                const SizedBox(width: 4),
                Text(
                  passenger.status,
                  style: TextStyle(
                      color: pending ? AppColors.amberDeep : AppColors.mintDeep,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                showReportDialog(context, userName: passenger.name),
            icon: const Icon(Icons.flag_outlined, size: 15),
            color: AppColors.textMuted,
            tooltip: 'Reportar pasajero',
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.only(left: 6),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}

class _QuickActionsRow extends StatelessWidget {
  final List<(IconData, String, String, VoidCallback)> actions;
  const _QuickActionsRow({required this.actions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth < 640 ? 1 : 3;
      final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final action in actions)
            SizedBox(
              width: width,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: action.$4,
                  child: LiftedCard(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.mint.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(action.$1,
                              size: 17, color: AppColors.mintDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(action.$2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              Text(action.$3,
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _StatsAndHistoryColumn extends StatelessWidget {
  final bool compact;
  const _StatsAndHistoryColumn({required this.compact});

  @override
  Widget build(BuildContext context) {
    final stats = MockData.driverStats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiftedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TUS ESTADÍSTICAS',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mintDark.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_outlined,
                        size: 13, color: AppColors.mintDark),
                    const SizedBox(width: 6),
                    Text('Distintivo: Conductor confiable',
                        style: TextStyle(
                            color: AppColors.mintDeep,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _StatBlock(
                          value: '${stats.tripsCompleted}',
                          label: 'Viajes completados')),
                  Expanded(
                      child: _StatBlock(
                          value: '${stats.rating}★', label: 'Calificación')),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                      child: _StatBlock(
                          value: '${stats.co2Kg}kg',
                          label: 'CO2 ahorrado',
                          valueColor: AppColors.mintDeep)),
                  Expanded(
                      child: _StatBlock(
                          value: '\$${_formatShort(stats.earningsCop)}',
                          label: 'Ganancias del mes')),
                ],
              ),
            ],
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 20),
          DepthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CO2 AHORRADO POR MES',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 18),
                SizedBox(
                    height: 120,
                    child: _Co2Chart(points: MockData.co2ByMonthDriver)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DISTINTIVOS',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 14),
                for (final d in MockData.driverDistintivos) ...[
                  _DistintivoTile(distintivo: d),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        LiftedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HISTORIAL RECIENTE',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 6),
              for (final item in MockData.driverHistory)
                TripListItem(
                  name: item.route,
                  subtitle: item.date,
                  amountLabel: '+\$${_formatCop(item.amount)}',
                  status: 'Pagado',
                  statusColor: AppColors.mintDeep,
                  avatarColor: AppColors.blueAccent,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DistintivoTile extends StatelessWidget {
  final Distintivo distintivo;
  const _DistintivoTile({required this.distintivo});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.mintDark.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(distintivo.icon, size: 17, color: AppColors.mintDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(distintivo.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              Text(distintivo.description,
                  style: TextStyle(
                      fontSize: 11.5, color: AppColors.textMuted, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Co2Chart extends StatelessWidget {
  final List<Co2MonthPoint> points;
  const _Co2Chart({required this.points});

  @override
  Widget build(BuildContext context) {
    final maxKg = points.map((p) => p.kg).reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final p in points)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(p.kg.toStringAsFixed(0),
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 8 + (p.kg / maxKg) * 60,
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(p.label,
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CreateTripFullPanel extends StatelessWidget {
  const _CreateTripFullPanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final form = const _CreateTripCard();
      final rules = LiftedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REGLAS DEL VIAJE',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
            const SizedBox(height: 14),
            const _RuleRow(
                text:
                    'Horario permitido: lunes a viernes 4:00am–9:00pm, sábados 4:00am–6:00pm.'),
            const _RuleRow(
                text:
                    'Los cupos no pueden superar la capacidad de tu vehículo.'),
            const _RuleRow(
                text: 'El precio estimado debe ser mayor o igual a \$4.000.'),
            const _RuleRow(
                text: 'No puedes tener otro viaje activo al mismo tiempo.'),
            const _RuleRow(
                text:
                    'Puedes modificar o cancelar hasta 30 minutos antes del inicio.'),
          ],
        ),
      );

      if (isMobile) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [form, const SizedBox(height: 20), rules]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: form),
          const SizedBox(width: 24),
          Expanded(flex: 5, child: rules),
        ],
      );
    });
  }
}

class _RuleRow extends StatelessWidget {
  final String text;
  const _RuleRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 15, color: AppColors.mintDark),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      height: 1.4))),
        ],
      ),
    );
  }
}

class _CreateTripCard extends StatelessWidget {
  const _CreateTripCard();

  @override
  Widget build(BuildContext context) {
    return LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CREAR VIAJE',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 16),
          _LabeledField(label: 'Origen', hint: 'Portal 80'),
          const SizedBox(height: 12),
          _LabeledField(label: 'Destino', hint: 'Escuela Ing. Julio Garavito'),
          const SizedBox(height: 12),
          _LabeledField(label: 'Fecha y hora', hint: 'Lun 7:00 AM'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _LabeledField(label: 'Cupos', hint: '3')),
              const SizedBox(width: 10),
              Expanded(child: _LabeledField(label: 'Precio', hint: '\$4.500')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.deepGreenDarker,
                    content: Text(
                        'Viaje publicado. Ya aparece disponible para pasajeros.',
                        style: TextStyle(color: Colors.white, fontSize: 12.5)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: AppColors.deepGreenDarker,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Publicar viaje',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  const _LabeledField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: AppColors.mint)),
          ),
        ),
      ],
    );
  }
}

// --- Mis viajes: próximos e historial (Módulo 2) ---

class _MyTripsPanel extends StatelessWidget {
  const _MyTripsPanel();

  @override
  Widget build(BuildContext context) {
    final history = MockData.driverHistory;
    final totalEarned = history.fold<int>(0, (sum, h) => sum + h.amount);
    final avgEarned = history.isEmpty ? 0 : totalEarned ~/ history.length;

    final mainCard = LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('VIAJE PROGRAMADO',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const Divider(height: 24),
          TripListItem(
            name: 'Portal 80 → Escuela Ing. Julio Garavito',
            subtitle: 'Hoy · 7:00 AM · 3 cupos',
            amountLabel: '\$13.500',
            status: 'Activo',
            statusColor: AppColors.mintDeep,
            avatarColor: AppColors.blueAccent,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text('Modificar',
                        style: TextStyle(
                            color: AppColors.mintDeep,
                            fontWeight: FontWeight.w700,
                            fontSize: 12))),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: () {},
                    child: Text('Cancelar',
                        style: TextStyle(
                            color: AppColors.coralDeep,
                            fontWeight: FontWeight.w700,
                            fontSize: 12))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('HISTORIAL',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const Divider(height: 24),
          for (final item in history)
            TripListItem(
              name: item.route,
              subtitle: item.date,
              amountLabel: '+\$${_formatCop(item.amount)}',
              status: 'Completado',
              statusColor: AppColors.mintDeep,
              avatarColor: AppColors.blueAccent,
            ),
        ],
      ),
    );

    final sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
          child: DepthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('GANANCIAS',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _StatBlock(
                            value: '${history.length}',
                            label: 'Viajes completados')),
                    Expanded(
                        child: _StatBlock(
                            value: '\$${_formatShort(totalEarned)}',
                            label: 'Total ganado',
                            valueColor: AppColors.mintDeep)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _StatBlock(
                            value: '\$${_formatShort(avgEarned)}',
                            label: 'Promedio/viaje')),
                    Expanded(
                        child: _StatBlock(value: '3', label: 'Cupos libres hoy')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
          child: LiftedCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.mint.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.bolt_outlined,
                      size: 17, color: AppColors.mintDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Publica tu próximo viaje con anticipación: los conductores puntuales reciben más reservas.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [mainCard, const SizedBox(height: 16), sidebar],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: mainCard),
          const SizedBox(width: 24),
          SizedBox(width: 320, child: sidebar),
        ],
      );
    });
  }
}

// --- Mi vehículo (Módulo 6) ---

class _VehiclePanel extends StatelessWidget {
  const _VehiclePanel();

  @override
  Widget build(BuildContext context) {
    final v = MockData.driverVehicle;
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final showcase = VehicleShowcase(
        brandModel: '${v.brand} ${v.model}',
        rating: 4.8,
        carColor: v.carColor,
        specs: [
          (Icons.confirmation_number_outlined, 'Placa ${v.plate}'),
          (Icons.event_seat_outlined, '${v.capacity} puestos'),
        ],
      );
      final details = LiftedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DATOS DEL VEHÍCULO',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (v.verified ? AppColors.mint : AppColors.amber)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          v.verified
                              ? Icons.verified_outlined
                              : Icons.hourglass_empty,
                          size: 12,
                          color: v.verified
                              ? AppColors.mintDeep
                              : AppColors.amberDeep),
                      const SizedBox(width: 5),
                      Text(
                        v.verified ? 'Verificado' : 'Pendiente de verificación',
                        style: TextStyle(
                            color: v.verified
                                ? AppColors.mintDeep
                                : AppColors.amberDeep,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            _VehicleDetailRow(label: 'Marca', value: v.brand),
            _VehicleDetailRow(label: 'Modelo', value: v.model),
            _VehicleDetailRow(label: 'Placa', value: v.plate),
            _VehicleDetailRow(
                label: 'Capacidad', value: '${v.capacity} puestos'),
            _VehicleDetailRow(label: 'Licencia vence', value: v.licenseExpiry),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: const Text('Actualizar documentos',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.mintDeep,
                  side: BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );

      if (isMobile) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [showcase, const SizedBox(height: 20), details]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 260, child: showcase),
          const SizedBox(width: 24),
          Expanded(child: details),
        ],
      );
    });
  }
}

class _VehicleDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _VehicleDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// --- Seguridad (Módulo 5) ---

class _DriverSecurityPanel extends StatelessWidget {
  const _DriverSecurityPanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final left = DepthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BOTÓN DE EMERGENCIA',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const EmergencyButton(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Actívalo si detectas una situación de riesgo con un pasajero o durante la ruta. Se notifica a seguridad institucional al instante.',
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 12.5, height: 1.5),
            ),
          ],
        ),
      );

      final right = LiftedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REPORTES SOBRE MIS PASAJEROS',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
            const Divider(height: 24),
            for (final r in MockData.myFiledReports)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(r.reportedUser,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppColors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.hourglass_empty,
                                  size: 10, color: AppColors.amberDeep),
                              const SizedBox(width: 4),
                              Text(r.status,
                                  style: TextStyle(
                                      color: AppColors.amberDeep,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(r.description,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            height: 1.4)),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    showReportDialog(context, userName: 'un pasajero'),
                icon: const Icon(Icons.flag_outlined, size: 15),
                label: const Text('Reportar un pasajero',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.coralDeep,
                  side: BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );

      if (isMobile) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 20), right]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: left),
          const SizedBox(width: 24),
          Expanded(flex: 5, child: right),
        ],
      );
    });
  }
}

String _formatShort(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
  return '$value';
}

String _formatCop(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final posFromEnd = s.length - i;
    buffer.write(s[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _StatBlock({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.textDark)),
        Text(label,
            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
      ],
    );
  }
}
