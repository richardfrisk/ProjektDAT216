import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/model/shop_category.dart';
import 'package:imat_app/pages/deals_page.dart';
import 'package:imat_app/widgets/hover_scale.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DealsSection(),
          SizedBox(height: 32),
          _ShopHeroCard(),
          SizedBox(height: 28),
          _CategorySection(),
        ],
      ),
    );
  }
}

class _ShopHeroCard extends StatelessWidget {
  const _ShopHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FFF4), Color(0xFFE8F8EE)],
        ),
        border: Border.all(color: AppTheme.primaryGreen, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_bag_rounded,
            size: 48,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(height: 12),
          const Text(
            'Handla varor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1a2e5a),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sök eller välj en kategori för att börja handla',
            style: TextStyle(fontSize: 16, color: Color(0xFF5a7060)),
          ),
          const SizedBox(height: 20),
          const _SearchBar(),
        ],
      ),
    );
  }
}

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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
      ),
      onSubmitted: (query) {
        if (query.trim().isNotEmpty) {
          context.read<PageHandler>().navigateToCategory('search:${query.trim()}');
        }
      },
    );
  }
}

class _DealsSection extends StatelessWidget {
  const _DealsSection();

  @override
  Widget build(BuildContext context) {
    final deals = context.watch<ImatDataHandler>().getWeeklyDeals();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFBBF24), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.percent_rounded, color: Color(0xFF92400E), size: 28),
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
                onPressed: () => context
                    .read<PageHandler>()
                    .navigateToCategory(dealsCategoryId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Se alla erbjudanden →',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (deals.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
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
                    childAspectRatio: 0.75,
                  ),
                  itemCount: deals.length,
                  itemBuilder: (context, i) => DealCard(
                    product: deals[i].product,
                    originalPrice: deals[i].originalPrice,
                    validUntil: deals[i].validUntil,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

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
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
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
              itemCount: shopCategories.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return const _DealsCategoryCard();
                return _CategoryCard(category: shopCategories[i - 1]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _DealsCategoryCard extends StatelessWidget {
  const _DealsCategoryCard();

  @override
  Widget build(BuildContext context) {
    return HoverScale(
      hoverScale: 1.03,
      onTap: () =>
          context.read<PageHandler>().navigateToCategory(dealsCategoryId),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          border: Border.all(color: const Color(0xFFFBBF24), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDD5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.percent_rounded,
                color: Color(0xFFD97706),
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Erbjudanden',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ShopCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PageHandler>().navigateToCategory(category.id),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.borderLight, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: category.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, color: category.color, size: 36),
              ),
              const SizedBox(height: 12),
              Text(
                category.displayName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
