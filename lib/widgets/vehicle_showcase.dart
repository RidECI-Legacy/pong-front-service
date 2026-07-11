import 'package:flutter/material.dart';

import '../data/car_colors.dart';

/// Big gradient panel used to showcase a vehicle, mirroring the reference
/// dashboard's photo card (brand/model, rating, quick specs). The gradient
/// and glow match the real color of the car photo shown.
class VehicleShowcase extends StatelessWidget {
  final String brandModel;
  final double rating;
  final CarColor carColor;
  final List<(IconData, String)> specs;

  const VehicleShowcase({
    super.key,
    required this.brandModel,
    required this.rating,
    required this.carColor,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    final style = carColorStyles[carColor]!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradient,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: style.glow.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(style.assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                Icon(
                  i < rating.round() ? Icons.star : Icons.star_border,
                  size: 14,
                  color: style.textOnCard,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            brandModel,
            style: TextStyle(color: style.textOnCard, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          for (final spec in specs)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(spec.$1, size: 13, color: style.textOnCard.withValues(alpha: 0.85)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      spec.$2,
                      style: TextStyle(color: style.textOnCard.withValues(alpha: 0.85), fontSize: 11.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
