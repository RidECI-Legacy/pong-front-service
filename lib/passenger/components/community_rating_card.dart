import 'package:flutter/material.dart';

import '../theme.dart';
import 'glass_card.dart';

class ReviewSnippet {
  final String author;
  final double rating;
  final String comment;
  const ReviewSnippet({required this.author, required this.rating, required this.comment});
}

/// Average rating, completed rides, a reputation progress bar and a couple
/// of recent reviews — the passenger's standing in the community.
class CommunityRatingCard extends StatelessWidget {
  final double rating;
  final int completedRides;
  final List<ReviewSnippet> reviews;

  const CommunityRatingCard({super.key, required this.rating, required this.completedRides, this.reviews = const []});

  @override
  Widget build(BuildContext context) {
    final reputation = (rating / 5).clamp(0.0, 1.0);
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('REPUTACIÓN EN LA COMUNIDAD', style: LandingType.eyebrow(color: LandingColors.warning)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$rating', style: LandingType.sectionTitle(size: 40)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: List.generate(5, (i) => Icon(
                        i < rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 16,
                        color: const Color(0xFFFBBF24),
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$completedRides viajes completados', style: LandingType.body(size: 12.5)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: reputation,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(LandingColors.warning),
            ),
          ),
          if (reviews.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('RESEÑAS RECIENTES', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
            const SizedBox(height: 10),
            for (final review in reviews) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(review.author, style: LandingType.cardTitle(size: 12)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                            const SizedBox(width: 3),
                            Text('${review.rating}', style: LandingType.body(size: 11.5)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(review.comment, style: LandingType.body(size: 11.5)),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
