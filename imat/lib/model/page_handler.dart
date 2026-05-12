import 'package:flutter/material.dart';

enum ShopPage { home, shop, favorites, cart, recipes, account }

class PageHandler extends ChangeNotifier {
  ShopPage _currentPage = ShopPage.home;
  String? _selectedCategory;

  ShopPage get currentPage => _currentPage;
  String? get selectedCategory => _selectedCategory;

  void navigateTo(ShopPage page) {
    if (_currentPage != page) {
      _currentPage = page;
      if (page != ShopPage.shop) _selectedCategory = null;
      notifyListeners();
    }
  }

  void navigateToCategory(String category) {
    _selectedCategory = category;
    _currentPage = ShopPage.shop;
    notifyListeners();
  }

  void clearCategory() {
    _selectedCategory = null;
    notifyListeners();
  }
}
