import 'package:flutter/material.dart';

import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// SECTION 7 — Footer.
class FooterSection extends StatelessWidget {
  final void Function(String label) onNavTap;
  const FooterSection({super.key, required this.onNavTap});

  static const _socials = [Icons.public_rounded, Icons.camera_alt_outlined, Icons.alternate_email_rounded];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingColors.bgDeepest,
      child: ResponsiveContainer(
        maxWidth: 1180,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;
              final logo = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/branding/rideci_icon.png', width: 30, height: 30, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  Text('RidECI', style: LandingType.cardTitle(size: 17)),
                ],
              );

              final links = Wrap(
                spacing: 22,
                runSpacing: 10,
                children: [
                  for (final l in LandingNavbarLinksForFooter.links)
                    GestureDetector(
                      onTap: () => onNavTap(l),
                      child: Text(l, style: LandingType.navLink()),
                    ),
                ],
              );

              final socials = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final icon in _socials)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: LandingColors.glassBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 16, color: LandingColors.textSecondary),
                      ),
                    ),
                ],
              );

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    logo,
                    const SizedBox(height: 20),
                    links,
                    const SizedBox(height: 20),
                    socials,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  logo,
                  const SizedBox(width: 32),
                  Expanded(child: links),
                  socials,
                ],
              );
            }),
            const SizedBox(height: 32),
            Container(height: 1, color: LandingColors.glassBorder),
            const SizedBox(height: 24),
            Text(
              'Contacto: contacto@rideci.escuelaing.edu.co · Acceso restringido a correos '
              '@escuelaing.edu.co y @mail.escuelaing.edu.co',
              textAlign: TextAlign.center,
              style: LandingType.body(size: 12, color: LandingColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 RidECI\nProyecto desarrollado para la Escuela Colombiana de Ingeniería Julio Garavito.',
              textAlign: TextAlign.center,
              style: LandingType.body(size: 11.5, color: LandingColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared footer nav labels (kept separate from [LandingNavbar] to avoid a
/// circular import between navbar.dart and footer_section.dart).
class LandingNavbarLinksForFooter {
  LandingNavbarLinksForFooter._();
  static const links = ['Inicio', 'Cómo funciona', 'Seguridad', 'Beneficios', 'FAQ'];
}
