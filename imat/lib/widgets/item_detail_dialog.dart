import 'package:flutter/material.dart';
import 'package:imat/model/store_item.dart';
import 'package:imat/model/store_stock.dart';
import 'package:provider/provider.dart';

/// Call this from anywhere to show the item detail bottom sheet.
void showItemDetail(BuildContext context, StoreItem item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ItemDetailSheet(item: item),
  );
}

class ItemDetailSheet extends StatelessWidget {
  final StoreItem item;
  const ItemDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Watch stock so the stepper reflects live quantity
    final stock = context.watch<StoreStock>();
    // Get the live version of this item from stock
    final liveItem = stock.stock.firstWhere(
      (i) => i.id == item.id,
      orElse: () => item,
    );

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
          // ── Drag handle ───────────────────────────────────────────────
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
                  // ── Hero image ────────────────────────────────────────
                  Stack(
                    children: [
                      SizedBox(
                        height: 280,
                        width: double.infinity,
                        child: Image.network(
                          liveItem.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 64,
                                color: Colors.black26),
                          ),
                        ),
                      ),
                      // Badges top-left
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Row(
                          children: [
                            if (liveItem.isOrganic)
                              _Badge(
                                  label: 'Ekologisk',
                                  bg: const Color(0xFFEAF3DE),
                                  fg: const Color(0xFF3B6D11)),
                            if (liveItem.isOrganic && liveItem.isOnSale)
                              const SizedBox(width: 6),
                            if (liveItem.isOnSale)
                              _Badge(
                                  label: 'KAMPANJ',
                                  bg: const Color(0xFFEF4444),
                                  fg: Colors.white),
                          ],
                        ),
                      ),
                      // Close button top-right
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
                      // Favourite top-right (below close)
                      Positioned(
                        top: 56,
                        right: 12,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => stock.toggleFavourite(liveItem),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                liveItem.isFavourite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 22,
                                color: liveItem.isFavourite
                                    ? const Color(0xFFD85A30)
                                    : Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Info section ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category label
                        Text(
                          liveItem.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Name
                        Text(
                          liveItem.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Weight
                        Text(
                          '${liveItem.weight} · ${liveItem.unit}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black45),
                        ),
                        const SizedBox(height: 14),

                        // Rating row
                        _RatingRow(item: liveItem),
                        const SizedBox(height: 20),

                        // Price row
                        Row(
                          children: [
                            Text(
                              '${liveItem.price.toStringAsFixed(2)} kr',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: liveItem.isOnSale
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF1a2e1a),
                              ),
                            ),
                            if (liveItem.oldPrice != null) ...[
                              const SizedBox(width: 12),
                              Text(
                                '${liveItem.oldPrice!.toStringAsFixed(2)} kr',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '-${(((liveItem.oldPrice! - liveItem.price) / liveItem.oldPrice!) * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 28),
                        const Divider(),
                        const SizedBox(height: 20),

                        // Details section
                        const Text(
                          'Produktinformation',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(label: 'Kategori', value: liveItem.category),
                        _InfoRow(label: 'Vikt / Mängd', value: liveItem.weight),
                        _InfoRow(label: 'Enhet', value: liveItem.unit),
                        _InfoRow(
                            label: 'Ekologisk',
                            value: liveItem.isOrganic ? 'Ja ✓' : 'Nej'),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky bottom bar ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Color(0xFFD4E8D8))),
            ),
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
            child: Row(
              children: [
                if (liveItem.quantity > 0) ...[
                  // Stepper
                  _QuantityStepper(item: liveItem, stock: stock),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                          'I varukorgen (${liveItem.quantity})',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F6E56),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => stock.addToCart(liveItem),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Lägg i varukorg',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1d8a3c),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Supporting widgets ───────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final StoreItem item;
  const _RatingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final full = item.rating.floor();
    final half = (item.rating - full) >= 0.5;
    return Row(
      children: [
        ...List.generate(5, (i) {
          final icon = i < full
              ? Icons.star_rounded
              : (i == full && half)
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded;
          return Icon(icon, size: 22, color: const Color(0xFFBA7517));
        }),
        const SizedBox(width: 8),
        Text(
          '${item.rating}  (${item.reviewCount} recensioner)',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
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
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.black45, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final StoreItem item;
  final StoreStock stock;
  const _QuantityStepper({required this.item, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => stock.decreaseQuantity(item),
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.remove, size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('${item.quantity}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          InkWell(
            onTap: () => stock.increaseQuantity(item),
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.add, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
