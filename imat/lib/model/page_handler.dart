import 'package:flutter/material.dart';
 
enum ShopPage { shop, favorites, cart, account }
 
class PageHandler extends ChangeNotifier {
  ShopPage _currentPage = ShopPage.shop;
 
  ShopPage get currentPage => _currentPage;
 
  void navigateTo(ShopPage page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }
}
 