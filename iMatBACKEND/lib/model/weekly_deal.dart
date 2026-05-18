import 'package:imat_app/model/imat/product.dart';

class WeeklyDeal {
  final Product product;
  final double originalPrice;
  final DateTime validUntil;

  const WeeklyDeal({
    required this.product,
    required this.originalPrice,
    required this.validUntil,
  });

  double get salePrice => product.price;
}
