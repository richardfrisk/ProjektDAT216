import 'package:flutter/material.dart';
import 'package:imat/model/page_handler.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/model/store_stock.dart';
import 'package:imat/widgets/store_item_card.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  bool get isSearch => category.startsWith('search:');
  String get searchQuery => isSearch ? category.substring(7) : '';
  String get displayTitle =>
      isSearch ? 'Sök: "$searchQuery"' : category;

  List<StoreItem> _filtered(List<StoreItem> all) {
    if (isSearch) {
      final q = searchQuery.toLowerCase();
      return all
          .where((i) =>
              i.name.toLowerCase().contains(q) ||
              i.category.toLowerCase().contains(q))
          .toList();
    }
    return all.where((i) => i.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StoreStock>();
    final pageHandler = context.read<PageHandler>();
    final items = _filtered(stock.stock);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Back + Title bar ───────────────────────────────────────────
        Container(
          color: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () => pageHandler.clearCategory(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Tillbaka till butiken'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1d8a3c),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${items.length} produkter',
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── Product grid ───────────────────────────────────────────────
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text('Inga produkter hittades.',
                      style:
                          TextStyle(fontSize: 18, color: Colors.black45)))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final cols = constraints.maxWidth > 900
                        ? 4
                        : constraints.maxWidth > 600
                            ? 3
                            : 2;
                    return GridView.builder(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return StoreItemCard(
                          item: item,
                          onFavouriteToggled: (i) =>
                              stock.toggleFavourite(i),
                          onQuantityIncreased: (i) =>
                              stock.increaseQuantity(i),
                          onQuantityDecreased: (i) =>
                              stock.decreaseQuantity(i),
                          onQuantityChanged: (i, qty) => 
                              stock.updateQuantity(i, qty),
                          onAddToCart: (i) => stock.addToCart(i),
                        );
                      },
                    );
                  }),
                ),
        ),
      ],
    );
  }
}
