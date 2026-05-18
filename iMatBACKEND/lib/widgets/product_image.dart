import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final ImatDataHandler data;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.product,
    required this.data,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = data.getImageData(product);
    if (bytes != null) {
      return Image.memory(bytes, fit: fit, width: double.infinity);
    }

    return Container(
      color: const Color(0xFFE8F5EC),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colors.black26, size: 48),
    );
  }
}
