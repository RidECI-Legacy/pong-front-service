import 'package:flutter/material.dart';

/// Gradient banner with a large watermark icon. Used to give sidebars that
/// would otherwise trail off into empty background some visual weight.
class DecorativeBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final List<Color> gradientColors;

  const DecorativeBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -22,
              bottom: -22,
              child: Icon(icon,
                  size: 120, color: Colors.white.withValues(alpha: 0.16)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(message,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
