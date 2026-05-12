import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imat/model/store_item.dart';

class StoreStock extends ChangeNotifier {
  final List<StoreItem> _stock = [];

  List<StoreItem> get stock => List.unmodifiable(_stock);

  List<StoreItem> get cartItems =>
      _stock.where((i) => i.quantity > 0).toList();

  List<StoreItem> get favouriteItems =>
      _stock.where((i) => i.isFavourite).toList();

  List<StoreItem> get saleItems =>
      _stock.where((i) => i.isOnSale).toList();

  List<StoreItem> itemsByCategory(String category) =>
      _stock.where((i) => i.category == category).toList();

  double get cartTotal => _stock.fold(
        0,
        (sum, i) => sum + i.price * i.quantity,
      );

  int get cartCount =>
      _stock.fold(0, (sum, i) => sum + i.quantity);

  StoreStock() {
    _loadStock();
  }

  double? get fsWeight => null;

  void _loadStock() async {
    final String jsonString =
        await rootBundle.loadString('assets/items/store_items.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> data = jsonMap['items'];
    for (final itemJson in data) {
      _stock.add(StoreItem.fromJson(itemJson));
    }
    notifyListeners();
  }

  void _updateItem(StoreItem updated) {
    final idx = _stock.indexWhere((i) => i.id == updated.id);
    if (idx != -1) {
      _stock[idx] = updated;
      notifyListeners();
    }
  }

  void increaseQuantity(StoreItem item) {
    _updateItem(item.copyWith(quantity: item.quantity + 1));
  }

  void decreaseQuantity(StoreItem item) {
    if (item.quantity > 0) {
      _updateItem(item.copyWith(quantity: item.quantity - 1));
    }
  }

  void updateQuantity(StoreItem item, int quantity) {
    if (item.quantity >= 0) {
      _updateItem(item.copyWith(quantity: quantity));
    }
  }

  void addToCart(StoreItem item) {
    if (item.quantity == 0) {
      _updateItem(item.copyWith(quantity: 1));
    }
  }

  void removeFromCart(StoreItem item) {
    _updateItem(item.copyWith(quantity: 0));
  }

  void toggleFavourite(StoreItem item) {
    _updateItem(item.copyWith(isFavourite: !item.isFavourite));
  }
}
