import 'package:flutter/material.dart';
import 'package:imat/model/store_stock.dart';
import 'package:imat/widgets/store_item_card.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StoreStock>();
    final favItems = stock.favouriteItems;

    if (favItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 80, color: Colors.black26),
            SizedBox(height: 16),
            Text('Inga favoriter ännu',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45)),
            SizedBox(height: 8),
            Text('Tryck på hjärtat på en produkt för att spara den här',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38, fontSize: 15)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Text(
            'Favoriter (${favItems.length})',
            style:
                const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Padding(
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
                itemCount: favItems.length,
                itemBuilder: (context, i) {
                  final item = favItems[i];
                  return StoreItemCard(
                    item: item,
                    onFavouriteToggled: (it) =>
                        stock.toggleFavourite(it),
                    onQuantityIncreased: (it) =>
                        stock.increaseQuantity(it),
                    onQuantityDecreased: (it) =>
                        stock.decreaseQuantity(it),
                    onQuantityChanged: (it, qty) =>
                        stock.updateQuantity(it, qty),
                    onAddToCart: (it) => stock.addToCart(it),
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
