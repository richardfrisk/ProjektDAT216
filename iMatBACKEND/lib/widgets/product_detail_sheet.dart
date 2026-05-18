import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_image.dart';
import 'package:imat_app/widgets/quantity_stepper.dart';
import 'package:provider/provider.dart';

void showProductDetail(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ProductDetailSheet(product: product),
  );
}

class ProductDetailSheet extends StatelessWidget {
  final Product product;

  const ProductDetailSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final detail = data.getDetail(product);
    final inCart = data.cartAmountFor(product);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ProductImage(product: product, data: data),
                      ),
                      if (product.isEcological)
                        const Positioned(
                          top: 16,
                          left: 16,
                          child: _Badge(
                            label: 'Ekologisk',
                            bg: Color(0xFFEAF3DE),
                            fg: Color(0xFF3B6D11),
                          ),
                        ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.close_rounded, size: 22),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 56,
                        right: 12,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => data.toggleFavorite(product),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                data.isFavorite(product)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 22,
                                color: data.isFavorite(product)
                                    ? const Color(0xFFD85A30)
                                    : Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.price.toStringAsFixed(2)} kr ${product.unit}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Produktinformation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (detail != null) ...[
                          if (detail.brand.isNotEmpty)
                            _InfoRow(label: 'Märke', value: detail.brand),
                          if (detail.description.isNotEmpty)
                            _InfoRow(label: 'Beskrivning', value: detail.description),
                          if (detail.contents.isNotEmpty)
                            _InfoRow(label: 'Innehåll', value: detail.contents),
                          if (detail.origin.isNotEmpty)
                            _InfoRow(label: 'Ursprung', value: detail.origin),
                        ] else
                          const Text(
                            'Ingen extra produktinformation tillgänglig.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        _InfoRow(
                          label: 'Ekologisk',
                          value: product.isEcological ? 'Ja' : 'Nej',
                        ),
                        _InfoRow(label: 'Enhet', value: product.unit),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.borderLight)),
            ),
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              children: [
                if (inCart > 0) ...[
                  QuantityStepper(
                    quantity: inCart,
                    onDecrease: () =>
                        data.updateProductInCart(product, delta: -1),
                    onIncrease: () =>
                        data.updateProductInCart(product, delta: 1),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        'I varukorgen (${inCart == inCart.roundToDouble() ? inCart.toInt() : inCart})',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ] else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => data.addProductToCart(product),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text(
                        'Lägg i varukorg',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.black45)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
