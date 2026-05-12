import 'package:flutter/material.dart';
import 'package:imat/app_theme.dart';
import 'package:imat/model/page_handler.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/model/store_stock.dart';
import 'package:provider/provider.dart';

// ─── Category metadata ───────────────────────────────────────────────────────

class _CategoryInfo {
  final String name;
  final IconData icon;
  final Color color;
  final Color background;
  const _CategoryInfo(this.name, this.icon, this.color, this.background);
}

const List<_CategoryInfo> _categories = [
  _CategoryInfo('Mejeri', Icons.water_drop_rounded, Color(0xFF3B82F6),
      Color(0xFFDBEAFE)),
  _CategoryInfo('Frukt', Icons.apple_rounded, Color(0xFF22C55E),
      Color(0xFFDCFCE7)),
  _CategoryInfo('Grönsaker', Icons.eco_rounded, Color(0xFF16A34A),
      Color(0xFFDCFCE7)),
  _CategoryInfo('Kött & Fisk', Icons.kebab_dining_rounded, Color(0xFFEF4444),
      Color(0xFFFEE2E2)),
  _CategoryInfo('Bakverk', Icons.breakfast_dining_rounded, Color(0xFFF97316),
      Color(0xFFFFEDD5)),
  _CategoryInfo('Skafferi', Icons.kitchen_rounded, Color(0xFF8B5CF6),
      Color(0xFFEDE9FE)),
  _CategoryInfo('Dryck', Icons.local_drink_rounded, Color(0xFF06B6D4),
      Color(0xFFCFFAFE)),
];

// ─── Store page ──────────────────────────────────────────────────────────────

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DealsSection(),
          SizedBox(height: 32),
          _SearchBar(),
          SizedBox(height: 28),
          _CategorySection(),
        ],
      ),
    );
  }
}

// ─── Search bar ──────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: 'Sök efter produkter...',
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: const Icon(Icons.search_rounded, size: 26),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4E8D8), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4E8D8), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1d8a3c), width: 2),
        ),
      ),
      onSubmitted: (query) {
        if (query.trim().isNotEmpty) {
          context
              .read<PageHandler>()
              .navigateToCategory('search:${query.trim()}');
        }
      },
    );
  }
}

// ─── Deals section ───────────────────────────────────────────────────────────

class _DealsSection extends StatelessWidget {
  const _DealsSection();

  @override
  Widget build(BuildContext context) {
    final saleItems = context.watch<StoreStock>().saleItems;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFBBF24), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              const Icon(Icons.percent_rounded,
                  color: Color(0xFF92400E), size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Veckans bästa erbjudanden',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Se alla erbjudanden →',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Deal cards
          LayoutBuilder(builder: (context, constraints) {
            final cols = constraints.maxWidth > 700
                ? 3
                : constraints.maxWidth > 450
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: saleItems.take(3).length,
              itemBuilder: (context, i) =>
                  _DealCard(item: saleItems[i]),
            );
          }),
        ],
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final StoreItem item;
  const _DealCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<PageHandler>().navigateToCategory(item.category),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFDE68A)),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item.imageUrl, fit: BoxFit.cover),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'KAMPANJ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(2)} kr',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444)),
                      ),
                      const SizedBox(width: 8),
                      if (item.oldPrice != null)
                        Text(
                          '${item.oldPrice!.toStringAsFixed(2)} kr',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                              decoration: TextDecoration.lineThrough),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.unit,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category grid ───────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategorier',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1a2e1a)),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final cols = constraints.maxWidth > 800
              ? 4
              : constraints.maxWidth > 500
                  ? 3
                  : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, i) => _CategoryCard(info: _categories[i]),
          );
        }),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryInfo info;
  const _CategoryCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<PageHandler>().navigateToCategory(info.name),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: const Color(0xFFD4E8D8), width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 2))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: info.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(info.icon, color: info.color, size: 36),
              ),
              const SizedBox(height: 12),
              Text(
                info.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
