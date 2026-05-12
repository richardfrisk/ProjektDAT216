import 'package:flutter/material.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/model/store_stock.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StoreStock>();
    final cartItems = stock.cartItems;

    if (cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.black26),
            SizedBox(height: 16),
            Text('Varukorgen är tom',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45)),
            SizedBox(height: 8),
            Text('Lägg till produkter för att fortsätta',
                style: TextStyle(color: Colors.black38, fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: Colors.white,
          child: const Text(
            'Varukorg',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
        ),
        const Divider(height: 1),

        // Items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) =>
                _CartItemRow(item: cartItems[i], stock: stock),
          ),
        ),

        // Footer total + checkout
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFD4E8D8))),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Totalt',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(
                    '${stock.cartTotal.toStringAsFixed(2)} kr',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1d8a3c),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Gå till kassan →',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final StoreItem item;
  final StoreStock stock;
  const _CartItemRow({required this.item, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported_outlined)),
            ),
          ),
          const SizedBox(width: 14),

          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text('${item.price.toStringAsFixed(2)} kr · ${item.weight}',
                    style: const TextStyle(
                        color: Colors.black45, fontSize: 13)),
              ],
            ),
          ),

          // Stepper
          _Stepper(item: item, stock: stock),

          // Remove button
          IconButton(
            onPressed: () => stock.removeFromCart(item),
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.black38),
            tooltip: 'Ta bort',
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final StoreItem item;
  final StoreStock stock;
  const _Stepper({required this.item, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => stock.decreaseQuantity(item),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.remove, size: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('${item.quantity}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          InkWell(
            onTap: () => stock.increaseQuantity(item),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
