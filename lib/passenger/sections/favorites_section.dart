import 'package:flutter/material.dart';

import '../components/empty_state.dart';
import '../components/favorite_driver_card.dart';
import '../passenger_actions.dart';
import '../passenger_mock_helpers.dart';
import '../theme.dart';

/// SECTION "Favoritos": grid of favorite drivers.
class FavoritesSection extends StatelessWidget {
  const FavoritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = PassengerMockHelpers.favoriteDrivers();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Conductores favoritos', style: LandingType.cardTitle(size: 18)),
        const SizedBox(height: 16),
        if (favorites.isEmpty)
          const EmptyState(
            icon: Icons.star_border_rounded,
            title: 'Aún no tienes conductores favoritos',
            description: 'Marca como favorito a los conductores con los que más viajas para encontrarlos rápido.',
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (var i = 0; i < favorites.length; i++)
                FavoriteDriverCard(
                  driver: favorites[i],
                  tripsTogether: 5 + i * 3,
                  onViewProfile: () => showActionSnack(context, 'Abriendo el perfil de ${favorites[i].driverName}.'),
                ),
            ],
          ),
      ],
    );
  }
}
