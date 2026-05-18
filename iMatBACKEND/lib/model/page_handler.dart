import 'package:flutter/material.dart';

enum ShopPage { home, shop, recipes, orders, profile, cart, checkout }

enum CheckoutStep { address, delivery, payment, confirm }

enum DeliveryOption { asap, scheduled }

enum PaymentMethod { cardOnDelivery, invoice, swish }

class PageHandler extends ChangeNotifier {
  ShopPage _currentPage = ShopPage.home;
  String? _selectedCategory;
  CheckoutStep _checkoutStep = CheckoutStep.address;
  DeliveryOption _deliveryOption = DeliveryOption.asap;
  PaymentMethod _paymentMethod = PaymentMethod.cardOnDelivery;

  ShopPage get currentPage => _currentPage;
  String? get selectedCategory => _selectedCategory;
  CheckoutStep get checkoutStep => _checkoutStep;
  DeliveryOption get deliveryOption => _deliveryOption;
  PaymentMethod get paymentMethod => _paymentMethod;

  int get checkoutStepIndex => _checkoutStep.index;
  int get checkoutStepCount => CheckoutStep.values.length;

  void navigateTo(ShopPage page) {
    if (_currentPage == page && page != ShopPage.shop) return;
    _currentPage = page;
    if (page != ShopPage.shop) _selectedCategory = null;
    if (page != ShopPage.checkout) _checkoutStep = CheckoutStep.address;
    notifyListeners();
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

  void startCheckout() {
    _checkoutStep = CheckoutStep.address;
    _currentPage = ShopPage.checkout;
    notifyListeners();
  }

  void setCheckoutStep(CheckoutStep step) {
    _checkoutStep = step;
    notifyListeners();
  }

  void nextCheckoutStep() {
    if (_checkoutStep.index < CheckoutStep.values.length - 1) {
      _checkoutStep = CheckoutStep.values[_checkoutStep.index + 1];
      notifyListeners();
    }
  }

  void previousCheckoutStep() {
    if (_checkoutStep.index > 0) {
      _checkoutStep = CheckoutStep.values[_checkoutStep.index - 1];
      notifyListeners();
    }
  }

  void setDeliveryOption(DeliveryOption option) {
    _deliveryOption = option;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void cancelCheckout() {
    _checkoutStep = CheckoutStep.address;
    navigateTo(ShopPage.cart);
  }
}
