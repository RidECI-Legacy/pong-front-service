import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/chat_dialog.dart';
import '../widgets/decorative_banner.dart';
import '../widgets/depth_card.dart';
import '../widgets/edit_contact_dialog.dart';
import '../widgets/emergency_button.dart';
import '../widgets/live_route_map.dart';
import '../widgets/report_dialog.dart';
import '../widgets/route_timeline.dart';
import '../widgets/trip_list_item.dart';
import '../widgets/vehicle_showcase.dart';

enum _PassengerTab { home, search, myTrips, profile, security }

/// Consistent minimum height for sidebar cards
const _sidebarCardMinHeight = 140.0;

const _passengerNavItems = [
  SidebarItem(icon: Icons.home_outlined, label: 'Inicio'),
  SidebarItem(icon: Icons.search, label: 'Buscar viajes'),
  SidebarItem(icon: Icons.receipt_long_outlined, label: 'Mis viajes'),
  SidebarItem(icon: Icons.emoji_events_outlined, label: 'Mi perfil'),
  SidebarItem(icon: Icons.shield_outlined, label: 'Seguridad'),
];

const _safetyTips = [
  (
    Icons.share_location_outlined,
    'Comparte tu ubicación en tiempo real con tu contacto de confianza durante el viaje.'
  ),
  (
    Icons.badge_outlined,
    'Verifica que la placa y el conductor coincidan con lo mostrado en la app antes de subir.'
  ),
  (
    Icons.lock_outline,
    'Evita compartir información personal sensible con conductores o pasajeros desconocidos.'
  ),
];

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  _PassengerTab _tab = _PassengerTab.home;

  static const _subtitles = {
    _PassengerTab.home: 'Panel principal',
    _PassengerTab.search: 'Encuentra un viaje compatible con tu horario',
    _PassengerTab.myTrips: 'Historial y reservas',
    _PassengerTab.profile: 'Reputación, distintivos e impacto',
    _PassengerTab.security: 'Contactos de confianza y reportes',
  };

  @override
  Widget build(BuildContext context) {
    final rider = MockData.riderProfile;

    return AppShell(
      roleIcon: Icons.explore_outlined,
      roleLabel: 'Pasajero',
      title: _tab == _PassengerTab.home
          ? 'Hola, ${rider.name.split(' ').first} 👋'
          : _titleFor(_tab),
      subtitle: _subtitles[_tab]!,
      avatarInitials: _initials(rider.name),
      navItems: _passengerNavItems,
      navSelectedIndex: _PassengerTab.values.indexOf(_tab),
      onNavSelect: (i) => setState(() => _tab = _PassengerTab.values[i]),
      trailing: _tab == _PassengerTab.home
          ? Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _tab = _PassengerTab.search),
                  child: Tooltip(
                    message: 'Buscar un viaje',
                    child: Icon(Icons.search, size: 20, color: AppColors.mintDark),
                  ),
                ),
              ),
            )
          : null,
      child: _buildBody(rider),
    );
  }

  String _titleFor(_PassengerTab tab) {
    switch (tab) {
      case _PassengerTab.home:
        return 'Inicio';
      case _PassengerTab.search:
        return 'Buscar viajes';
      case _PassengerTab.myTrips:
        return 'Mis viajes';
      case _PassengerTab.profile:
        return 'Mi perfil';
      case _PassengerTab.security:
        return 'Seguridad';
    }
  }

  Widget _buildBody(RiderProfile rider) {
    switch (_tab) {
      case _PassengerTab.home:
        return LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < kMobileBreakpoint;
          final left = _ActiveTripPanel(rider: rider);
          final right = _AvailableTripsPanel(rider: rider);
          final quickActions = _QuickActionsRow(
            actions: [
              (
                Icons.receipt_long_outlined,
                'Mis viajes',
                'Historial y reservas activas',
                () => setState(() => _tab = _PassengerTab.myTrips)
              ),
              (
                Icons.emoji_events_outlined,
                'Mi perfil',
                'Distintivos e impacto ambiental',
                () => setState(() => _tab = _PassengerTab.profile)
              ),
              (
                Icons.shield_outlined,
                'Seguridad',
                'Contacto de confianza y reportes',
                () => setState(() => _tab = _PassengerTab.security)
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
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: left),
                  const SizedBox(width: 24),
                  SizedBox(width: 360, child: right),
                ],
              ),
              const SizedBox(height: 24),
              quickActions,
            ],
          );
        });
      case _PassengerTab.search:
        return const _SearchTripsPanel();
      case _PassengerTab.myTrips:
        return const _MyTripsPanel();
      case _PassengerTab.profile:
        return _ProfilePanel(
            rider: rider,
            onViewAllTrips: () => setState(() => _tab = _PassengerTab.myTrips));
      case _PassengerTab.security:
        return const _SecurityPanel();
    }
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

class _ActiveTripPanel extends StatelessWidget {
  final RiderProfile rider;
  const _ActiveTripPanel({required this.rider});

  @override
  Widget build(BuildContext context) {
    final trip = MockData.activeTrip;

    return DepthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VIAJE ACTIVO',
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
                      color: AppColors.mint.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 12, color: AppColors.mintDeep),
                        const SizedBox(width: 5),
                        Text(trip.status,
                            style: TextStyle(
                                color: AppColors.mintDeep,
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
            final vehicle = VehicleShowcase(
              brandModel: trip.car,
              rating: 4.8,
              carColor: trip.carColor,
              specs: const [
                (Icons.speed, 'Aire acondicionado'),
                (Icons.battery_charging_full, 'Nivel de gasolina: 78%'),
              ],
            );
            final info = _DriverInfoPanel(trip: trip);

            if (isNarrow) {
              return Column(
                children: [
                  SizedBox(width: double.infinity, child: vehicle),
                  const SizedBox(height: 16),
                  info,
                ],
              );
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
            final mapBlock = SizedBox(
              height: 190,
              width: double.infinity,
              child: LiveRouteMap(
                origin: const LatLng(4.7097552, -74.1108357),
                destination: const LatLng(4.7822229, -74.0443381),
                originLabel: 'Portal 80',
                destinationLabel: 'Escuela Ing. Julio Garavito',
                driverName: trip.driverName,
                etaMinutes: trip.etaMinutes,
                progress: (1 - trip.etaMinutes / 15).clamp(0.08, 0.92),
              ),
            );
            final timeline = Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: RouteTimeline(
                stops: const [
                  RouteStop(
                      label: 'Punto de partida',
                      detail: 'Portal 80, 6:34 AM',
                      dotColor: AppColors.mint),
                  RouteStop(
                      label: 'Punto de llegada',
                      detail: 'Escuela Ing. Julio Garavito',
                      dotColor: AppColors.coral),
                ],
              ),
            );

            if (isNarrow) {
              return Column(
                children: [mapBlock, const SizedBox(height: 12), timeline],
              );
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
        ],
      ),
    );
  }
}

class _DriverInfoPanel extends StatelessWidget {
  final ActiveTrip trip;
  const _DriverInfoPanel({required this.trip});

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
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.mint,
                child: Text(_initials(trip.driverName),
                    style: const TextStyle(
                        color: AppColors.deepGreenDarker,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.driverName,
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                    Text(trip.car,
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _MiniInfo(
                      label: 'Llega en', value: '${trip.etaMinutes} min')),
              Expanded(child: _MiniInfo(label: 'Precio', value: '\$4.500')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  showChatDialog(context, withName: trip.driverName),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('Chatear con conductor',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: AppColors.deepGreenDarker,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
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

class _AvailableTripsPanel extends StatefulWidget {
  final RiderProfile rider;
  const _AvailableTripsPanel({required this.rider});

  @override
  State<_AvailableTripsPanel> createState() => _AvailableTripsPanelState();
}

class _AvailableTripsPanelState extends State<_AvailableTripsPanel> {
  bool _showSearch = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiftedCard(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  child: _Tab(
                      label: 'Buscar viajes',
                      active: _showSearch,
                      onTap: () => setState(() => _showSearch = true))),
              Expanded(
                  child: _Tab(
                      label: 'Mis viajes',
                      active: !_showSearch,
                      onTap: () => setState(() => _showSearch = false))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LiftedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      _showSearch
                          ? 'Viajes disponibles'
                          : 'Historial de viajes',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textDark)),
                  Icon(Icons.search, size: 18, color: AppColors.textMuted),
                ],
              ),
              const Divider(height: 24),
              if (_showSearch)
                for (int i = 0; i < MockData.availableTrips.length; i++) ...[
                  _TripRow(trip: MockData.availableTrips[i]),
                  if (i != MockData.availableTrips.length - 1)
                    const Divider(height: 8),
                ]
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                      child: Text('Aún no tienes viajes reservados.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12.5))),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ProfileCard(rider: widget.rider),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.textDark : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final TripOffer trip;
  const _TripRow({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TripListItem(
          name: trip.driverName,
          subtitle: '${trip.origin} → ${trip.destination} · ${trip.time}',
          amountLabel: '\$${_formatCop(trip.price)}',
          status: '${trip.seats} cupos',
          statusColor: AppColors.mintDark,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.deepGreenDarker,
                  content: Text(
                      'Cupo reservado con ${trip.driverName}. Revisa "Mis viajes".',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.5)),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Reservar',
                style: TextStyle(
                    color: AppColors.mintDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ),
      ],
    );
  }
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

class _ProfileCard extends StatelessWidget {
  final RiderProfile rider;
  const _ProfileCard({required this.rider});

  @override
  Widget build(BuildContext context) {
    return LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TU PERFIL',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.amber,
                child: Text(_initials(rider.name),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rider.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13.5)),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 13, color: AppColors.amber),
                        const SizedBox(width: 2),
                        Text('${rider.rating} · ${rider.trips} viajes',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 13, color: AppColors.amber),
                SizedBox(width: 6),
                Text('Distintivo: Pasajero frecuente',
                    style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _MiniStat(value: '${rider.trips}', label: 'Viajes'),
              _MiniStat(
                  value: '${rider.co2Kg}kg',
                  label: 'CO2 ahorrado',
                  valueColor: AppColors.mintDark),
              _MiniStat(
                  value: '\$${_formatShort(rider.savedCop)}',
                  label: 'Ahorrado'),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatShort(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
  return '$value';
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _MiniStat({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: valueColor ?? AppColors.textDark)),
          Text(label,
              style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// --- Búsqueda de viajes (Módulo 3 - PS-01) ---

class _SearchTripsPanel extends StatefulWidget {
  const _SearchTripsPanel();

  @override
  State<_SearchTripsPanel> createState() => _SearchTripsPanelState();
}

class _SearchTripsPanelState extends State<_SearchTripsPanel> {
  String _filter = 'Hora';
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyRouteFilter(String origin) {
    _searchController.text = origin;
    setState(() => _query = origin);
  }

  List<TripOffer> get _filteredTrips {
    final trips = MockData.availableTrips.where((t) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return t.origin.toLowerCase().contains(q) ||
          t.destination.toLowerCase().contains(q) ||
          t.driverName.toLowerCase().contains(q);
    }).toList();
    switch (_filter) {
      case 'Destino':
        trips.sort((a, b) => a.origin.compareTo(b.origin));
      case 'Cercanía':
        trips.sort((a, b) => a.price.compareTo(b.price));
      default:
        trips.sort((a, b) => a.time.compareTo(b.time));
    }
    return trips;
  }

  @override
  Widget build(BuildContext context) {
    final trips = _filteredTrips;
    final avgPrice = trips.isEmpty
        ? 0
        : trips.map((t) => t.price).reduce((a, b) => a + b) ~/ trips.length;
    final totalSeats = trips.fold<int>(0, (sum, t) => sum + t.seats);

    final searchCard = LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BUSCAR VIAJE',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: 'Busca por origen, destino o conductor…',
              hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
              prefixIcon:
                  Icon(Icons.search, size: 20, color: AppColors.textMuted),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.close,
                          size: 18, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.mint, width: 1.5)),
            ),
          ),
          const SizedBox(height: 14),
          Text('FILTRAR POR',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in const ['Hora', 'Destino', 'Cercanía'])
                ChoiceChip(
                  label: Text(f, style: const TextStyle(fontSize: 12)),
                  selected: _filter == f,
                  selectedColor: AppColors.mint.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                      color: _filter == f
                          ? AppColors.mintDark
                          : AppColors.textMuted,
                      fontWeight: FontWeight.w600),
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Viajes disponibles · $_filter',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.textDark)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.mint.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999)),
                child: Text('${trips.length}',
                    style: TextStyle(
                        color: AppColors.mintDeep,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (trips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No hay viajes que coincidan con tu búsqueda.',
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
              ),
            )
          else
            for (int i = 0; i < trips.length; i++) ...[
              _TripRow(trip: trips[i]),
              if (i != trips.length - 1) const Divider(height: 8),
            ],
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
                Text('RESUMEN DE BÚSQUEDA',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(value: '${trips.length}', label: 'Viajes hoy'),
                    _MiniStat(
                        value: '$totalSeats',
                        label: 'Cupos libres',
                        valueColor: AppColors.mintDark),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(
                        value: '\$${_formatShort(avgPrice)}',
                        label: 'Precio promedio'),
                    _MiniStat(
                        value: '0.9kg',
                        label: 'CO2 evitado/viaje',
                        valueColor: AppColors.mintDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: _sidebarCardMinHeight,
          child: LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RUTAS FRECUENTES',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final origin in {
                          for (final t in MockData.availableTrips) t.origin
                        })
                          Material(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(999),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: () => _applyRouteFilter(origin),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.place_outlined,
                                        size: 13, color: AppColors.mintDark),
                                    const SizedBox(width: 6),
                                    Text(origin,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
          child: LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CONDUCTORES MEJOR CALIFICADOS',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 14),
                for (final driver in _topRatedDrivers) ...[
                  _TopDriverTile(trip: driver),
                  if (driver != _topRatedDrivers.last) const Divider(height: 20),
                ],
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
                      color: AppColors.amber.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.eco_outlined,
                      size: 17, color: AppColors.amberDeep),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Compartir un viaje ahorra en promedio 0.9kg de CO2 frente a ir en carro solo. ¡Cada trayecto suma!',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
          child: const DecorativeBanner(
            icon: Icons.groups_outlined,
            title: 'Viaja acompañado',
            message:
                'Entre más estudiantes compartan ruta, más cupos y mejores precios para todos.',
            gradientColors: [AppColors.blueAccent, AppColors.mintDark],
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [searchCard, const SizedBox(height: 16), sidebar],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: searchCard),
          const SizedBox(width: 24),
          SizedBox(width: 320, child: sidebar),
        ],
      );
    });
  }

  List<TripOffer> get _topRatedDrivers {
    final trips = [...MockData.availableTrips]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return trips.take(3).toList();
  }
}

class _TopDriverTile extends StatelessWidget {
  final TripOffer trip;
  const _TopDriverTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.blueAccent.withValues(alpha: 0.16),
          child: Text(_initials(trip.driverName),
              style: const TextStyle(
                  color: AppColors.blueAccentDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 11)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trip.driverName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 12.5)),
              Text(trip.car,
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 13, color: AppColors.amber),
            const SizedBox(width: 3),
            Text('${trip.rating}',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

// --- Mis viajes: historial y reservas (Módulo 3 - PS-04) ---

class _MyTripsPanel extends StatefulWidget {
  const _MyTripsPanel();

  @override
  State<_MyTripsPanel> createState() => _MyTripsPanelState();
}

class _MyTripsPanelState extends State<_MyTripsPanel> {
  final _searchController = TextEditingController();
  String _query = '';
  String _sort = 'Recientes';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HistoryItem> get _filteredHistory {
    final all = MockData.passengerHistory;
    final filtered = _query.isEmpty
        ? all
        : all
            .where((h) => h.route.toLowerCase().contains(_query.toLowerCase()))
            .toList();
    final sorted = [...filtered];
    if (_sort == 'Mayor gasto') {
      sorted.sort((a, b) => b.amount.compareTo(a.amount));
    }
    return sorted;
  }

  void _downloadReceipt(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepGreenDarker,
        content: Text('Comprobante de "${item.route}" enviado a tu correo.',
            style: const TextStyle(color: Colors.white, fontSize: 12.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = MockData.passengerHistory;
    final visibleHistory = _filteredHistory;
    final totalSpent = history.fold<int>(0, (sum, h) => sum + h.amount);
    final avgSpent = history.isEmpty ? 0 : totalSpent ~/ history.length;
    final routeCounts = <String, int>{};
    for (final h in history) {
      routeCounts[h.route] = (routeCounts[h.route] ?? 0) + 1;
    }
    final topRoute = routeCounts.entries.isEmpty
        ? null
        : (routeCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first;

    final historyCard = LiftedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('HISTORIAL DE VIAJES',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              Text('${visibleHistory.length} viajes',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Busca por ruta…',
              hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
              prefixIcon:
                  Icon(Icons.search, size: 19, color: AppColors.textMuted),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.close,
                          size: 17, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              isDense: true,
              filled: true,
              fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.mint, width: 1.5)),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in const ['Recientes', 'Mayor gasto'])
                ChoiceChip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  selected: _sort == s,
                  selectedColor: AppColors.mint.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                      color:
                          _sort == s ? AppColors.mintDark : AppColors.textMuted,
                      fontWeight: FontWeight.w600),
                  onSelected: (_) => setState(() => _sort = s),
                ),
            ],
          ),
          const Divider(height: 28),
          if (visibleHistory.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No se encontraron viajes con esa búsqueda.',
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
              ),
            )
          else
            for (final item in visibleHistory)
              Row(
                children: [
                  Expanded(
                    child: TripListItem(
                      name: item.route,
                      subtitle: item.date,
                      amountLabel: '\$${_formatCop(item.amount)}',
                      status: 'Completado',
                      statusColor: AppColors.mintDark,
                      avatarColor: AppColors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _downloadReceipt(item),
                    tooltip: 'Descargar comprobante',
                    icon: Icon(Icons.receipt_long_outlined,
                        size: 18, color: AppColors.textMuted),
                  ),
                ],
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
                Text('RESUMEN',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(
                        value: '${history.length}', label: 'Viajes totales'),
                    _MiniStat(
                        value: '\$${_formatShort(totalSpent)}',
                        label: 'Total pagado'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(
                        value: '\$${_formatShort(avgSpent)}',
                        label: 'Promedio/viaje',
                        valueColor: AppColors.mintDark),
                    _MiniStat(
                        value: '${history.length}kg',
                        label: 'CO2 evitado',
                        valueColor: AppColors.mintDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
            child: LiftedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('GASTO POR VIAJE',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 110,
                    child: _MiniBarChart(
                      points: [
                        for (final item in history.reversed)
                          (
                            item.date.split(' ').first,
                            '\$${_formatShort(item.amount)}',
                            item.amount.toDouble()
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (topRoute != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
            child: LiftedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('RUTA MÁS FRECUENTE',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.blueAccent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.alt_route,
                            size: 17, color: AppColors.blueAccentDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topRoute.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12.5)),
                            Text('${topRoute.value} viajes registrados',
                                style: TextStyle(
                                    fontSize: 11.5, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
                      color: AppColors.amber.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.receipt_long_outlined,
                      size: 17, color: AppColors.amberDeep),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Toca el ícono de recibo junto a cada viaje para descargar su comprobante.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _sidebarCardMinHeight),
          child: const DecorativeBanner(
            icon: Icons.savings_outlined,
            title: 'Sigue ahorrando',
            message:
                'Cada viaje compartido reduce lo que gastarías yendo solo. Revisa tu progreso cada semana.',
            gradientColors: [AppColors.violet, AppColors.blueAccentDark],
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [historyCard, const SizedBox(height: 16), sidebar],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: historyCard),
          const SizedBox(width: 24),
          SizedBox(width: 320, child: sidebar),
        ],
      );
    });
  }
}

// --- Mi perfil: reputación, distintivos, impacto (Módulo 6 / 8) ---

const _tripMilestones = [10, 25, 50, 100, 200];

class _ProfilePanel extends StatelessWidget {
  final RiderProfile rider;
  final VoidCallback onViewAllTrips;
  const _ProfilePanel({required this.rider, required this.onViewAllTrips});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final left = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiftedCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.amber,
                  child: Text(_initials(rider.name),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rider.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17)),
                      Text(rider.faculty,
                          style: TextStyle(
                              fontSize: 12.5, color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: AppColors.amber),
                          const SizedBox(width: 4),
                          Text('${rider.rating} · ${rider.trips} viajes',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                for (final d in MockData.passengerDistintivos) ...[
                  _DistintivoTile(distintivo: d),
                  const SizedBox(height: 12),
                ],
                const Divider(height: 12),
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  final next = _tripMilestones.firstWhere(
                      (m) => m > rider.trips,
                      orElse: () => _tripMilestones.last);
                  final prev = _tripMilestones
                      .lastWhere((m) => m <= rider.trips, orElse: () => 0);
                  final progress =
                      ((rider.trips - prev) / (next - prev)).clamp(0.0, 1.0);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Próximo distintivo: Viajero experto',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 12.5)),
                          Text('${rider.trips}/$next viajes',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.border,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.amber),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ACTIVIDAD RECIENTE',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                    TextButton(
                      onPressed: onViewAllTrips,
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: const Text('Ver todo',
                          style: TextStyle(
                              color: AppColors.mintDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                  ],
                ),
                const Divider(height: 24),
                for (final item in MockData.passengerHistory.take(3))
                  TripListItem(
                    name: item.route,
                    subtitle: item.date,
                    amountLabel: '\$${_formatCop(item.amount)}',
                    status: 'Completado',
                    statusColor: AppColors.mintDark,
                    avatarColor: AppColors.blueAccent,
                  ),
              ],
            ),
          ),
        ],
      );

      final right = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DepthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('IMPACTO AMBIENTAL',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                    _Co2TrendBadge(points: MockData.co2ByMonthPassenger),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${rider.co2Kg}kg de CO2 ahorrados este semestre',
                    style: TextStyle(
                        color: AppColors.mintDeep,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 18),
                SizedBox(
                    height: 120,
                    child: _Co2Chart(points: MockData.co2ByMonthPassenger)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RESUMEN',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _MiniStat(value: '${rider.trips}', label: 'Viajes totales'),
                    _MiniStat(
                        value: '\$${_formatShort(rider.savedCop)}',
                        label: 'Ahorrado',
                        valueColor: AppColors.mintDark),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const DecorativeBanner(
            icon: Icons.military_tech_outlined,
            title: 'Más distintivos por desbloquear',
            message:
                'Sigue viajando de forma segura y sostenible para completar tu colección de logros.',
            gradientColors: [AppColors.amber, AppColors.coral],
          ),
        ],
      );

      if (isMobile) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 24), right]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 24),
          Expanded(child: right),
        ],
      );
    });
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
              color: AppColors.amber.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(distintivo.icon, size: 17, color: AppColors.amber),
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

class _Co2TrendBadge extends StatelessWidget {
  final List<Co2MonthPoint> points;
  const _Co2TrendBadge({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    final current = points.last.kg;
    final previous = points[points.length - 2].kg;
    final change =
        previous == 0 ? 0.0 : ((current - previous) / previous) * 100;
    final isUp = change >= 0;
    final color = isUp ? AppColors.mintDeep : AppColors.coral;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isUp ? Icons.trending_up : Icons.trending_down,
              size: 13, color: color),
          const SizedBox(width: 4),
          Text(
              '${change.abs().toStringAsFixed(0)}% vs ${points[points.length - 2].label}',
              style: TextStyle(
                  color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      ),
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
                  Text(p.kg.toStringAsFixed(1),
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

class _MiniBarChart extends StatelessWidget {
  final List<(String label, String valueLabel, double value)> points;
  const _MiniBarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final maxValue = points.map((p) => p.$3).reduce((a, b) => a > b ? a : b);
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
                  Text(p.$2,
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 8 + (p.$3 / maxValue) * 50,
                      color: AppColors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(p.$1,
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

// --- Seguridad: contacto de emergencia y reportes (Módulo 5) ---

class _SecurityPanel extends StatefulWidget {
  const _SecurityPanel();

  @override
  State<_SecurityPanel> createState() => _SecurityPanelState();
}

class _SecurityPanelState extends State<_SecurityPanel> {
  EmergencyContact _contact = MockData.emergencyContact;
  bool _autoShareLocation = true;
  final List<bool> _tipsRead = List.filled(_safetyTips.length, false);

  Future<void> _editContact() async {
    final updated = await showEditContactDialog(context, contact: _contact);
    if (updated == null || !mounted) return;
    setState(() => _contact = updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepGreenDarker,
        content: Text('Contacto de confianza actualizado.',
            style: TextStyle(color: Colors.white, fontSize: 12.5)),
      ),
    );
  }

  void _toggleAutoShare(bool value) {
    setState(() => _autoShareLocation = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepGreenDarker,
        content: Text(
          value
              ? 'Compartirás tu ubicación automáticamente al iniciar un viaje.'
              : 'Ya no compartirás tu ubicación automáticamente.',
          style: const TextStyle(color: Colors.white, fontSize: 12.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contact = _contact;
    final readCount = _tipsRead.where((r) => r).length;
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < kMobileBreakpoint;
      final left = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DepthCard(
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
                  'Si te sientes en riesgo durante un viaje activo, presiona el botón SOS para compartir tu ubicación en tiempo real con tu contacto de confianza y con seguridad institucional.',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 12.5, height: 1.5),
                ),
                const Divider(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Compartir ubicación automáticamente',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(
                            _autoShareLocation
                                ? 'Activado · se envía a tu contacto de confianza al iniciar cada viaje'
                                : 'Desactivado · solo se comparte si presionas SOS',
                            style: TextStyle(
                                fontSize: 11.5, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _autoShareLocation,
                      activeTrackColor: AppColors.mint,
                      onChanged: _toggleAutoShare,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTACTO DE CONFIANZA',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.violet.withValues(alpha: 0.16),
                      child: Text(_initials(contact.name),
                          style: const TextStyle(
                              color: AppColors.violet,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contact.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13.5)),
                          Text('${contact.relation} · ${contact.phone}',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: _editContact,
                        child: const Text('Editar',
                            style: TextStyle(
                                color: AppColors.mintDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 12))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CONSEJOS DE SEGURIDAD',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                    Text('$readCount/${_safetyTips.length} leídos',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: readCount / _safetyTips.length,
                    minHeight: 4,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.mint),
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < _safetyTips.length; i++) ...[
                  _SafetyTipRow(
                    icon: _safetyTips[i].$1,
                    text: _safetyTips[i].$2,
                    checked: _tipsRead[i],
                    onChanged: (v) => setState(() => _tipsRead[i] = v),
                  ),
                  if (i != _safetyTips.length - 1) const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
      );

      final right = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MIS REPORTES',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                    TextButton.icon(
                      onPressed: () =>
                          showReportDialog(context, userName: 'un usuario'),
                      icon: const Icon(Icons.flag_outlined, size: 14),
                      label: const Text('Nuevo reporte',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.coral),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (MockData.myFiledReports.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('No has enviado reportes.',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 12.5)),
                  )
                else
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
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.amber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(999)),
                                child: Text(r.status,
                                    style: const TextStyle(
                                        color: AppColors.amber,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(r.description,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                  height: 1.4)),
                          const SizedBox(height: 4),
                          Text(r.date,
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LiftedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('REPORTES RECIBIDOS',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const Divider(height: 24),
                if (MockData.reportsAboutMe.isEmpty)
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.mint.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.verified_user_outlined,
                            size: 17, color: AppColors.mintDeep),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No has recibido reportes de otros usuarios. ¡Sigue viajando de forma segura!',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              height: 1.5),
                        ),
                      ),
                    ],
                  )
                else
                  for (final r in MockData.reportsAboutMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(r.description,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              height: 1.4)),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const DecorativeBanner(
            icon: Icons.verified_user_outlined,
            title: 'Comunidad segura',
            message:
                'Todos los conductores y pasajeros están verificados. Reporta cualquier comportamiento inusual.',
            gradientColors: [AppColors.mintDark, AppColors.violet],
          ),
        ],
      );

      if (isMobile) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 24), right]);
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

class _SafetyTipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool checked;
  final ValueChanged<bool> onChanged;
  const _SafetyTipRow(
      {required this.icon,
      required this.text,
      required this.checked,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onChanged(!checked),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.violet.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 17, color: AppColors.violet),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: checked
                      ? AppColors.textMuted.withValues(alpha: 0.6)
                      : AppColors.textMuted,
                  height: 1.4,
                  decoration: checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: checked,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: AppColors.mint,
              checkColor: AppColors.deepGreenDarker,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
