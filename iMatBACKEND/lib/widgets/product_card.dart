import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/hover_scale.dart';
import 'package:imat_app/widgets/product_detail_sheet.dart';
import 'package:imat_app/widgets/product_image.dart';
import 'package:imat_app/widgets/quantity_stepper.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showCampaignBadge;

  const ProductCard({
    super.key,
    required this.product,
    this.showCampaignBadge = false,
  });

  void _openDetail(BuildContext context) {
    showProductDetail(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final inCart = data.cartAmountFor(product);

    return HoverScale(
      onTap: () => _openDetail(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(product: product, data: data),
                  if (showCampaignBadge)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'KAMPANJ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.paddingMediumSmall,
                AppTheme.paddingMediumSmall,
                AppTheme.paddingMediumSmall,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.price.toStringAsFixed(0)} kr ${product.unit}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
            if (inCart > 0)
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMediumSmall),
                child: QuantityStepper(
                  fullWidth: true,
                  quantity: inCart,
                  onDecrease: () =>
                      data.updateProductInCart(product, delta: -1),
                  onIncrease: () =>
                      data.updateProductInCart(product, delta: 1),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMediumSmall),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => data.addProductToCart(product),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('+ Lägg till'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DealCard extends StatelessWidget {
  final Product product;
  final double originalPrice;
  final DateTime validUntil;

  const DealCard({
    super.key,
    required this.product,
    required this.originalPrice,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final inCart = data.cartAmountFor(product);
    final date =
        '${validUntil.year}-${validUntil.month.toString().padLeft(2, '0')}-${validUntil.day.toString().padLeft(2, '0')}';

    return HoverScale(
      onTap: () => showProductDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFDE68A)),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(product: product, data: data),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'KAMPANJ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} kr',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${originalPrice.toStringAsFixed(0)} kr',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        ' ${product.unit}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gäller t.o.m $date',
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
            if (inCart > 0)
              Padding(
                padding: const EdgeInsets.all(14),
                child: QuantityStepper(
                  fullWidth: true,
                  quantity: inCart,
                  onDecrease: () =>
                      data.updateProductInCart(product, delta: -1),
                  onIncrease: () =>
                      data.updateProductInCart(product, delta: 1),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => data.addProductToCart(product),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('+ Lägg till'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
