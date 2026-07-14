import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../components/dashboard_hero.dart';
import '../components/dashboard_insights_tabs.dart';
import '../components/favorite_driver_card.dart';
import '../components/live_map_card.dart';
import '../components/loading_skeleton.dart';
import '../components/nearby_trips_section.dart';
import '../components/notification_card.dart';
import '../components/passenger_search_card.dart';
import '../components/quick_actions_grid.dart';
import '../components/reservation_card.dart';
import '../components/trip_card.dart';
import '../passenger_actions.dart';
import '../passenger_mock_helpers.dart';
import '../passenger_section.dart';
import '../theme.dart';

/// SECTION "Dashboard": the rich overview described by the design brief —
/// greeting, search card, recommended trips, upcoming reservation, quick
/// actions, favorites/notifications, community rating, security and
/// sustainability, and nearby trips.
class DashboardSection extends StatefulWidget {
  final RiderProfile rider;
  final ActiveTrip activeTrip;
  final List<TripOffer> trips;
  final List<NotificationItem> notifications;
  final ValueChanged<PassengerSection> onNavigate;

  const DashboardSection({
    super.key,
    required this.rider,
    required this.activeTrip,
    required this.trips,
    required this.notifications,
    required this.onNavigate,
  });

  @override
  State<DashboardSection> createState() => _DashboardSectionState();
}

class _DashboardSectionState extends State<DashboardSection> {
  final _mapKey = GlobalKey();

  void _scrollToMap() {
    final ctx = _mapKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic, alignment: 0.08);
  }

  @override
  Widget build(BuildContext context) {
    final favorites = PassengerMockHelpers.favoriteDrivers();
    final nearby = PassengerMockHelpers.nearbyTrips();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardHero(name: widget.rider.name.split(' ').first),
        const SizedBox(height: 28),
        PassengerSearchCard(
          onSearch: (criteria) => showActionSnack(context, 'Buscando viajes de ${criteria.origin} a ${criteria.destination}…', icon: Icons.search_rounded),
        ),
        const SizedBox(height: 36),
        _SectionHeader(title: 'Viajes recomendados', actionLabel: 'Ver todos', onAction: () => widget.onNavigate(PassengerSection.search)),
        const SizedBox(height: 16),
        _RecommendedTrips(trips: widget.trips),
        const SizedBox(height: 36),
        ReservationCard(
          trip: widget.activeTrip,
          meetingPoint: 'Portal 80',
          onViewDetails: () => widget.onNavigate(PassengerSection.reservations),
          onChat: () => showTripChatDialog(context, withName: widget.activeTrip.driverName),
          onEmergency: () => showEmergencyDialog(context),
        ),
        const SizedBox(height: 20),
        LiveMapCard(
          key: _mapKey,
          driverName: widget.activeTrip.driverName,
          originLabel: 'Portal 80',
          destinationLabel: 'Escuela Ing. Julio Garavito',
          etaMinutes: widget.activeTrip.etaMinutes,
          progress: 0.32,
          onExpand: () => widget.onNavigate(PassengerSection.reservations),
        ),
        const SizedBox(height: 36),
        _SectionHeader(title: 'Acciones rápidas'),
        const SizedBox(height: 16),
        QuickActionsGrid(actions: [
          QuickAction(icon: Icons.search_rounded, label: 'Buscar viaje', accent: LandingColors.accent, onTap: () => widget.onNavigate(PassengerSection.search)),
          QuickAction(icon: Icons.map_rounded, label: 'Ver mapa', accent: LandingColors.primaryLight, onTap: _scrollToMap),
          QuickAction(icon: Icons.star_rounded, label: 'Conductores favoritos', accent: const Color(0xFFFBBF24), onTap: () => widget.onNavigate(PassengerSection.favorites)),
          QuickAction(icon: Icons.sos_rounded, label: 'Emergencia', accent: LandingColors.danger, onTap: () => showEmergencyDialog(context)),
          QuickAction(icon: Icons.call_rounded, label: 'Contactar conductor', accent: LandingColors.success, onTap: () => showTripChatDialog(context, withName: widget.activeTrip.driverName)),
          QuickAction(icon: Icons.report_problem_rounded, label: 'Reportar incidente', accent: LandingColors.warning, onTap: () => widget.onNavigate(PassengerSection.security)),
        ]),
        const SizedBox(height: 36),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final favoritesBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Conductores favoritos', actionLabel: 'Ver todos', onAction: () => widget.onNavigate(PassengerSection.favorites)),
              const SizedBox(height: 16),
              SizedBox(
                height: 336,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (context, i) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => FavoriteDriverCard(
                    entry: favorites[i],
                    onViewProfile: () => widget.onNavigate(PassengerSection.favorites),
                    onMessage: () => showTripChatDialog(context, withName: favorites[i].driver.driverName),
                    onToggleFavorite: () => widget.onNavigate(PassengerSection.favorites),
                  ),
                ),
              ),
            ],
          );

          final notificationsBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notificaciones recientes', style: LandingType.cardTitle(size: 16)),
              const SizedBox(height: 16),
              for (final n in widget.notifications.take(3)) ...[
                NotificationCard(notification: n),
                const SizedBox(height: 10),
              ],
            ],
          );

          if (isMobile) {
            return Column(children: [favoritesBlock, const SizedBox(height: 28), notificationsBlock]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: favoritesBlock),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: notificationsBlock),
            ],
          );
        }),
        const SizedBox(height: 36),
        _SectionHeader(title: 'Tu actividad'),
        const SizedBox(height: 16),
        DashboardInsightsTabs(
          rider: widget.rider,
          onEmergency: () => showEmergencyDialog(context),
          onReport: () => widget.onNavigate(PassengerSection.security),
          onOpenSecurityCenter: () => widget.onNavigate(PassengerSection.security),
        ),
        const SizedBox(height: 36),
        _SectionHeader(title: 'Viajes cercanos'),
        const SizedBox(height: 16),
        NearbyTripsSection(
          trips: nearby,
          onReserve: (offer) => showActionSnack(context, 'Cupo reservado con ${offer.driverName}.'),
        ),
      ],
    );
  }
}

class _RecommendedTrips extends StatefulWidget {
  final List<TripOffer> trips;
  const _RecommendedTrips({required this.trips});

  @override
  State<_RecommendedTrips> createState() => _RecommendedTripsState();
}

class _RecommendedTripsState extends State<_RecommendedTrips> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      int columns = 3;
      if (width < 1100) columns = 2;
      if (width < 700) columns = 1;
      final gap = 16.0;
      final cardWidth = (width - (columns - 1) * gap) / columns;

      if (_loading) {
        return const _SkeletonGrid();
      }

      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final trip in widget.trips)
            SizedBox(
              width: cardWidth,
              child: TripCard(
                trip: trip,
                onReserve: () => showActionSnack(context, 'Cupo reservado con ${trip.driverName}. Revisa "Mis Reservas".'),
              ),
            ),
        ],
      );
    });
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      int columns = 3;
      if (width < 1100) columns = 2;
      if (width < 700) columns = 1;
      final gap = 16.0;
      final cardWidth = (width - (columns - 1) * gap) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (var i = 0; i < columns; i++) SizedBox(width: cardWidth, height: 230, child: const TripCardSkeleton())],
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: LandingType.cardTitle(size: 18)),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text(actionLabel!, style: const TextStyle(color: LandingColors.accent, fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}
