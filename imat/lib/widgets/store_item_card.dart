import 'package:flutter/material.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/widgets/item_detail_dialog.dart';

class StoreItemCard extends StatelessWidget {
  final StoreItem item;
  final ValueChanged<StoreItem> onFavouriteToggled;
  final ValueChanged<StoreItem> onQuantityIncreased;
  final ValueChanged<StoreItem> onQuantityDecreased;
  //final ValueChanged<StoreItem> onQuantityChanged;
  final ValueChanged<StoreItem> onAddToCart;

  final void Function(StoreItem, int) onQuantityChanged;

  const StoreItemCard({
    super.key,
    required this.item,
    required this.onFavouriteToggled,
    required this.onQuantityIncreased,
    required this.onQuantityDecreased,
    required this.onQuantityChanged,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder gives us the true rendered width of this card so every
    // size value is derived from it — no hardcoded breakpoints needed.
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        // ── Scale factors derived from card width ──────────────────────────
        // A "reference" card is ~320 px wide (single-column on a tablet).
        // Everything scales proportionally from there.
        final scale = (w / 320).clamp(0.45, 1.0);

        final pad        = 14.0 * scale;
        final padSmall   =  8.0 * scale;
        final padTiny    =  4.0 * scale;

        final fsCategory = 11.0 * scale;
        final fsName     = 18.0 * scale;
        final fsWeight   = 13.0 * scale;
        final fsPrice    = 22.0 * scale;
        final fsOldPrice = 13.0 * scale;
        final fsUnit     = 11.0 * scale;
        final fsReviews  = 11.0 * scale;
        final fsCartBtn  = 13.0 * scale;

        final starSize   = 16.0 * scale;
        final iconSize   = 18.0 * scale;
        final favSize    = 20.0 * scale;
        final stepperIcon= 18.0 * scale;
        final stepperPad =  7.0 * scale;
        final stepperHPad= 10.0 * scale;
        final badgePadH  =  8.0 * scale;
        final badgePadV  =  3.0 * scale;
        final fsBadge    = 10.0 * scale;
        final cartHeight = 40.0 * scale;


        // ── Helpers ────────────────────────────────────────────────────────

        Widget buildBadge(String label, Color bg, Color fg) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: badgePadH, vertical: badgePadV),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fsBadge,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          );
        }

        Widget buildRating() {
          final fullStars = item.rating.floor();
          final hasHalf   = (item.rating - fullStars) >= 0.5;
          return Row(
            children: [
              ...List.generate(5, (i) {
                final icon = i < fullStars
                    ? Icons.star_rounded
                    : (i == fullStars && hasHalf)
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded;
                return Icon(icon, size: starSize, color: const Color(0xFFBA7517));
              }),
              SizedBox(width: 4 * scale),
              Text(
                '(${item.reviewCount})',
                style: TextStyle(fontSize: fsReviews, color: Colors.black54),
              ),
            ],
          );
        }

        Widget buildQtyStepper() {
          final controller = TextEditingController(
            text: item.quantity.toString(),
          );

          return Container(
            decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // − button
              Semantics(
                label: 'Decrease quantity',
                button: true,
                child: InkWell(
                  onTap: () => onQuantityDecreased(item),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.all(stepperPad),
                    child: Icon(Icons.remove, size: stepperIcon),
                  ),
                ),
              ),

              SizedBox(
                width: w * 0.7,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: fsWeight,
                    fontWeight: FontWeight.w600,
                  ),
                  onSubmitted: (value) {
                    final qty = int.tryParse(value);

                    if (qty != null && qty >= 0) {
                      onQuantityChanged(item, qty);
                    } else {
                      controller.text = item.quantity.toString();
                    }
                  },
                ),
              ),
              // + button
              Semantics(
                label: 'Increase quantity',
                button: true,
                child: InkWell(
                  onTap: () => onQuantityIncreased(item),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.all(stepperPad),
                    child: Icon(Icons.add, size: stepperIcon),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    

        // ── Card ───────────────────────────────────────────────────────────
        return GestureDetector(
          onTap: () => showItemDetail(context, item),
          child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image + Badges + Favourite ─────────────────────────────
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48 * scale,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ),

                  // Badges (top-left)
                  Positioned(
                    top: padSmall,
                    left: padSmall,
                    child: Row(
                      children: [
                        if (item.isOrganic)
                          buildBadge('Organic', const Color(0xFFEAF3DE), const Color(0xFF3B6D11)),
                        if (item.isOrganic && item.isOnSale)
                          SizedBox(width: 4 * scale),
                        if (item.isOnSale)
                          buildBadge('Sale', const Color(0xFFFAECE7), const Color(0xFF993C1D)),
                      ],
                    ),
                  ),

                  // Favourite button (top-right)
                  Positioned(
                    top: padSmall,
                    right: padSmall,
                    child: Semantics(
                      label: item.isFavourite ? 'Remove from favourites' : 'Add to favourites',
                      button: true,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => onFavouriteToggled(item),
                          child: Padding(
                            padding: EdgeInsets.all(padTiny + 2 * scale),
                            child: Icon(
                              item.isFavourite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: favSize,
                              color: item.isFavourite
                                  ? const Color(0xFFD85A30)
                                  : Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Card Body ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(pad, pad * 0.85, pad, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category label
                    Text(
                      item.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: fsCategory,
                        letterSpacing: 1.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: padTiny),

                    // Product name — max 2 lines, never clips
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fsName,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2 * scale),

                    // Weight
                    Text(
                      item.weight,
                      style: TextStyle(fontSize: fsWeight, color: Colors.black54),
                    ),
                    SizedBox(height: padSmall),

                    // Price row — wraps gracefully if space is tight
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4 * scale,
                      children: [
                        Text(
                          '${item.price.toStringAsFixed(2)}kr',
                          style: TextStyle(
                            fontSize: fsPrice,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (item.oldPrice != null)
                          Text(
                            '${item.oldPrice!.toStringAsFixed(2)}kr',
                            style: TextStyle(
                              fontSize: fsOldPrice,
                              color: Colors.black38,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          item.unit,
                          style: TextStyle(fontSize: fsUnit, color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(height: padSmall),

                    // Star rating
                    //buildRating(),
                  ],
                ),
              ),

              SizedBox(height: padSmall),
              const Divider(height: 1, thickness: 0.5),

              // ── Card Footer ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(pad * 0.7, padSmall, pad * 0.7, padSmall),
                child: Row(
                  children: [
                    // Quantity stepper
                    if (item.quantity > 0) 
                      buildQtyStepper()     
                    else
                    // Add to cart button
                    Expanded(
                      child: Semantics(
                        label: 'Lägg till i kundvagn',
                        button: true,
                        child: ElevatedButton.icon(
                          onPressed: () => onAddToCart(item),
                          icon: Icon(Icons.shopping_cart_outlined, size: iconSize),
                          label: Text(
                            'Lägg i kundvagn',
                            style: TextStyle(fontSize: fsCartBtn),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.quantity > 0
                                ? const Color(0xFF0F6E56)
                                : const Color(0xFF1D9E75),
                            foregroundColor: const Color(0xFFE1F5EE),
                            minimumSize: Size(0, cartHeight),
                            padding: EdgeInsets.symmetric(horizontal: 6 * scale),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}
