import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/widgets/product_image.dart';
import 'package:imat_app/widgets/quantity_stepper.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final items = data.getShoppingCart().items;

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.black26),
            SizedBox(height: 16),
            Text(
              'Din varukorg är tom',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lägg till produkter för att fortsätta',
              style: TextStyle(color: Colors.black38, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          margin: const EdgeInsets.all(AppTheme.paddingLarge),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Din varukorg',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _CartItemRow(item: items[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Totalt:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${data.shoppingCartTotal().toStringAsFixed(0)} kr',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: data.shoppingCartClear,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Töm varukorg'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () =>
                                context.read<PageHandler>().startCheckout(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Gå till kassan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final ShoppingItem item;

  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final data = context.read<ImatDataHandler>();

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 64,
            height: 64,
            child: ProductImage(product: item.product, data: data),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Text(
                '${item.product.price.toStringAsFixed(0)} kr${item.product.unit}',
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ),
        QuantityStepper(
          quantity: item.amount,
          onDecrease: () =>
              data.updateProductInCart(item.product, delta: -1),
          onIncrease: () =>
              data.updateProductInCart(item.product, delta: 1),
        ),
        const SizedBox(width: 12),
        Text(
          '${item.total.toStringAsFixed(0)} kr',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ],
    );
  }
}
