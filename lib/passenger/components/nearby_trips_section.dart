import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'profile_avatar.dart';

/// A single nearby-trip entry: distance to pickup and a departure
/// countdown, on top of the usual [TripOffer] fields.
class NearbyTrip {
  final TripOffer offer;
  final double distanceKm;
  final int departsInMinutes;

  const NearbyTrip({required this.offer, required this.distanceKm, required this.departsInMinutes});
}

class NearbyTripsSection extends StatelessWidget {
  final List<NearbyTrip> trips;
  final ValueChanged<TripOffer> onReserve;

  const NearbyTripsSection({super.key, required this.trips, required this.onReserve});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trips.length,
        separatorBuilder: (context, i) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final trip = trips[i];
          return SizedBox(
            width: 260,
            child: GlassCard(
              radius: 16,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ProfileAvatar(name: trip.offer.driverName, size: 32),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(trip.offer.driverName, style: LandingType.cardTitle(size: 12), overflow: TextOverflow.ellipsis),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFBBF24)),
                                const SizedBox(width: 2),
                                Text('${trip.offer.rating}', style: LandingType.body(size: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.near_me_rounded, size: 12, color: LandingColors.accent),
                      const SizedBox(width: 5),
                      Text('${trip.distanceKm.toStringAsFixed(1)} km', style: LandingType.body(size: 11, color: LandingColors.accent)),
                      const SizedBox(width: 10),
                      Icon(Icons.timer_outlined, size: 12, color: LandingColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('${trip.departsInMinutes} min', style: LandingType.body(size: 11)),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: 'Reservar',
                      onTap: () => onReserve(trip.offer),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
