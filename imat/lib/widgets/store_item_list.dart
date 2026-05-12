import 'package:flutter/material.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/model/store_stock.dart';
import 'package:imat/widgets/store_item_card.dart';
import 'package:provider/provider.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    var storeStock = context.watch<StoreStock>();
    var stock = storeStock.stock;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: stock.length,
      itemBuilder: (context, index) {
        final item = stock[index];
        return StoreItemCard(
          item: item,
          onFavouriteToggled: (StoreItem value) {},
          onQuantityIncreased: (StoreItem value) {},
          onQuantityDecreased: (StoreItem value) {},
          onQuantityChanged: (StoreItem value, int quantity) {},
          onAddToCart: (StoreItem value) {},
        );
      },
    );
  }
}