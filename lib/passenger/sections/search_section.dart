import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../components/empty_state.dart';
import '../components/passenger_search_card.dart';
import '../components/trip_card.dart';
import '../passenger_actions.dart';
import '../theme.dart';

/// SECTION "Buscar Viajes": the search card plus a live-filtered grid of
/// available trips.
class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  String _query = '';

  List<TripOffer> get _results {
    if (_query.isEmpty) return MockData.availableTrips;
    final q = _query.toLowerCase();
    return MockData.availableTrips.where((t) => t.origin.toLowerCase().contains(q) || t.destination.toLowerCase().contains(q) || t.driverName.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PassengerSearchCard(
          onSearch: (criteria) => setState(() => _query = criteria.origin),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Viajes disponibles', style: LandingType.cardTitle(size: 18)),
            Text('${results.length} resultados', style: LandingType.body(size: 12, color: LandingColors.textTertiary)),
          ],
        ),
        const SizedBox(height: 16),
        if (results.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados',
            description: 'No encontramos viajes que coincidan con tu búsqueda. Intenta con otro origen o destino.',
            actionLabel: 'Limpiar búsqueda',
            onAction: () => setState(() => _query = ''),
          )
        else
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            int columns = 3;
            if (width < 1100) columns = 2;
            if (width < 700) columns = 1;
            final gap = 16.0;
            final cardWidth = (width - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final trip in results)
                  SizedBox(
                    width: cardWidth,
                    child: TripCard(trip: trip, onReserve: () => showActionSnack(context, 'Cupo reservado con ${trip.driverName}.')),
                  ),
              ],
            );
          }),
      ],
    );
  }
}
