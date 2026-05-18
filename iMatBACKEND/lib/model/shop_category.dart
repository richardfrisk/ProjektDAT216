import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';

class ShopCategory {
  final String id;
  final String displayName;
  final IconData icon;
  final Color color;
  final Color background;
  final List<ProductCategory> productCategories;

  const ShopCategory({
    required this.id,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.background,
    required this.productCategories,
  });

  bool matches(Product product) => productCategories.contains(product.category);
}

const List<ShopCategory> shopCategories = [
  ShopCategory(
    id: 'mejeri',
    displayName: 'Mejeri',
    icon: Icons.water_drop_rounded,
    color: Color(0xFF3B82F6),
    background: Color(0xFFDBEAFE),
    productCategories: [ProductCategory.DAIRIES],
  ),
  ShopCategory(
    id: 'frukt_gront',
    displayName: 'Frukt & Grönt',
    icon: Icons.apple_rounded,
    color: Color(0xFF22C55E),
    background: Color(0xFFDCFCE7),
    productCategories: [
      ProductCategory.FRUIT,
      ProductCategory.BERRY,
      ProductCategory.CITRUS_FRUIT,
      ProductCategory.EXOTIC_FRUIT,
      ProductCategory.VEGETABLE_FRUIT,
      ProductCategory.CABBAGE,
      ProductCategory.ROOT_VEGETABLE,
      ProductCategory.MELONS,
      ProductCategory.HERB,
    ],
  ),
  ShopCategory(
    id: 'kott_fisk',
    displayName: 'Kött & Fisk',
    icon: Icons.kebab_dining_rounded,
    color: Color(0xFFEF4444),
    background: Color(0xFFFEE2E2),
    productCategories: [ProductCategory.MEAT, ProductCategory.FISH],
  ),
  ShopCategory(
    id: 'bageri',
    displayName: 'Bageri',
    icon: Icons.breakfast_dining_rounded,
    color: Color(0xFFF97316),
    background: Color(0xFFFFEDD5),
    productCategories: [ProductCategory.BREAD, ProductCategory.SWEET],
  ),
  ShopCategory(
    id: 'skafferi',
    displayName: 'Skafferi',
    icon: Icons.kitchen_rounded,
    color: Color(0xFF8B5CF6),
    background: Color(0xFFEDE9FE),
    productCategories: [
      ProductCategory.PASTA,
      ProductCategory.FLOUR_SUGAR_SALT,
      ProductCategory.POTATO_RICE,
      ProductCategory.NUTS_AND_SEEDS,
      ProductCategory.POD,
    ],
  ),
  ShopCategory(
    id: 'dryck',
    displayName: 'Dryck',
    icon: Icons.local_drink_rounded,
    color: Color(0xFF06B6D4),
    background: Color(0xFFCFFAFE),
    productCategories: [ProductCategory.HOT_DRINKS, ProductCategory.COLD_DRINKS],
  ),
];

ShopCategory? shopCategoryById(String id) {
  for (final category in shopCategories) {
    if (category.id == id) return category;
  }
  return null;
}
