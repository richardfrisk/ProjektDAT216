import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/model/shop_category.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  bool get isSearch => categoryId.startsWith('search:');
  String get searchQuery => isSearch ? categoryId.substring(7) : '';

  String displayTitle(ImatDataHandler data) {
    if (isSearch) return 'Sök: "$searchQuery"';
    return shopCategoryById(categoryId)?.displayName ?? categoryId;
  }

  List<Product> _products(ImatDataHandler data) {
    if (isSearch) {
      return data.findProducts(searchQuery);
    }
    final category = shopCategoryById(categoryId);
    if (category == null) return [];
    return data.productsForShopCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final pageHandler = context.read<PageHandler>();
    final products = _products(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: pageHandler.clearCategory,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Tillbaka till butiken'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1d8a3c),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle(data),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${products.length} produkter',
                      style: const TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: products.isEmpty
              ? const Center(
                  child: Text(
                    'Inga produkter hittades.',
                    style: TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 900
                          ? 4
                          : constraints.maxWidth > 600
                          ? 3
                          : 2;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                            ProductCard(product: products[index]),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
