import 'package:flutter/material.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/widgets/hover_scale.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.read<PageHandler>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Välkommen till iMat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1a2e1a),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Din matbutik online – enkelt, snabbt och bekvämt',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Color(0xFF5a7060)),
                  ),
                  const SizedBox(height: 52),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cards = [
                        _HomeCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&fit=crop',
                          icon: Icons.shopping_cart_rounded,
                          iconColor: const Color(0xFF1d8a3c),
                          borderColor: const Color(0xFF1d8a3c),
                          title: 'Beställ hem',
                          subtitle: 'Handla mat och få det levererat hem',
                          onTap: () => pageHandler.navigateTo(ShopPage.shop),
                        ),
                        _HomeCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&fit=crop',
                          icon: Icons.restaurant_menu_rounded,
                          iconColor: const Color(0xFFe07b20),
                          borderColor: const Color(0xFFe07b20),
                          title: 'Recept',
                          subtitle: 'Hitta inspiration till middagen',
                          onTap: () =>
                              pageHandler.navigateTo(ShopPage.recipes),
                        ),
                      ];

                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: cards
                              .map(
                                (c) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: c,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Column(
                        children: cards
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: c,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.imageUrl,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverScale(
      hoverScale: 1.05,
      onTap: onTap,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xDDFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
