import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/live_route_map.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';

/// Real, interactive TomTom map card for the dashboard: shows the active
/// trip's live route (origin, destination, driver position and ETA) using
/// the shared [LiveRouteMap] widget (flutter_map + TomTom tiles/routing),
/// wrapped in the passenger dashboard's own glass card chrome so it reads
/// as one more dashboard module rather than a foreign embed.
class LiveMapCard extends StatelessWidget {
  final String driverName;
  final String originLabel;
  final String destinationLabel;
  final int etaMinutes;
  final double progress;
  final VoidCallback? onExpand;

  const LiveMapCard({
    super.key,
    required this.driverName,
    required this.originLabel,
    required this.destinationLabel,
    required this.etaMinutes,
    this.progress = 0.35,
    this.onExpand,
  });

  // Real Bogotá coordinates for the two campus-commute points referenced by
  // the mock data: Portal 80 (TransMilenio) and the Escuela Colombiana de
  // Ingeniería Julio Garavito (AK 45 Autopista Norte #205-59).
  static const _origin = LatLng(4.7108, -74.1132);
  static const _destination = LatLng(4.7620, -74.0445);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: LandingColors.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(11)),
                    child: const Icon(Icons.map_rounded, size: 18, color: LandingColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mapa en vivo', style: LandingType.cardTitle(size: 15)),
                      Text('Ruta con $driverName · TomTom', style: LandingType.body(size: 11.5)),
                    ],
                  ),
                ],
              ),
              if (onExpand != null) GhostIconButton(icon: Icons.open_in_full_rounded, tooltip: 'Ampliar mapa', onTap: onExpand, size: 34),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 320,
              child: LiveRouteMap(
                origin: _origin,
                destination: _destination,
                originLabel: originLabel,
                destinationLabel: destinationLabel,
                driverName: driverName,
                etaMinutes: etaMinutes,
                progress: progress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
