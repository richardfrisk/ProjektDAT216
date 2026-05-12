class StoreItem {
  final String id;
  final String name;
  final String category;
  final String weight;
  final double price;
  final double? oldPrice;
  final String unit;
  final bool isOrganic;
  final bool isOnSale;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final bool isFavourite;
  final int quantity;
 
  const StoreItem({
    required this.id,
    required this.name,
    required this.category,
    required this.weight,
    required this.price,
    this.oldPrice,
    required this.unit,
    this.isOrganic = false,
    this.isOnSale = false,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.isFavourite = false,
    this.quantity = 0,
  });
 
  StoreItem copyWith({
    String? id,
    String? name,
    String? category,
    String? weight,
    double? price,
    double? oldPrice,
    String? unit,
    bool? isOrganic,
    bool? isOnSale,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    bool? isFavourite,
    int? quantity,
  }) {
    return StoreItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      unit: unit ?? this.unit,
      isOrganic: isOrganic ?? this.isOrganic,
      isOnSale: isOnSale ?? this.isOnSale,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavourite ?? this.isFavourite,
      quantity: quantity ?? this.quantity,
    );
  }
 
  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      weight: json['weight'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      unit: json['unit'] as String,
      isOrganic: json['isOrganic'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrl: json['imageUrl'] as String,
      isFavourite: json['isFavourite'] as bool? ?? false,
      quantity: json['quantity'] as int? ?? 0,
    );
  }
}