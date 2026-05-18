import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/pages/cart_page.dart';
import 'package:imat_app/pages/category_page.dart';
import 'package:imat_app/pages/checkout_page.dart';
import 'package:imat_app/pages/deals_page.dart';
import 'package:imat_app/pages/home_page.dart';
import 'package:imat_app/pages/orders_page.dart';
import 'package:imat_app/pages/profile_page.dart';
import 'package:imat_app/pages/recipes_page.dart';
import 'package:imat_app/pages/store_page.dart';
import 'package:provider/provider.dart';

class ShopScaffold extends StatelessWidget {
  const ShopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();

    if (pageHandler.currentPage == ShopPage.home) {
      return const HomePage();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundMint,
      appBar: _buildAppBar(context, pageHandler),
      body: _buildBody(pageHandler),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PageHandler pageHandler,
  ) {
    final cartCount = context.watch<ImatDataHandler>().cartItemCount;
    final cartActive =
        pageHandler.currentPage == ShopPage.cart ||
        pageHandler.currentPage == ShopPage.checkout;

    return AppBar(
      title: GestureDetector(
        onTap: () => pageHandler.navigateTo(ShopPage.home),
        child: const Text(
          'iMat',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      actions: [
        _NavButton(
          label: 'Handla',
          icon: Icons.shopping_bag_rounded,
          active: pageHandler.currentPage == ShopPage.shop,
          onTap: () {
            pageHandler.clearCategory();
            pageHandler.navigateTo(ShopPage.shop);
          },
        ),
        _NavButton(
          label: 'Recept',
          icon: Icons.restaurant_menu_rounded,
          active: pageHandler.currentPage == ShopPage.recipes,
          onTap: () => pageHandler.navigateTo(ShopPage.recipes),
        ),
        _NavButton(
          label: 'Beställningar',
          icon: Icons.history_rounded,
          active: pageHandler.currentPage == ShopPage.orders,
          onTap: () => pageHandler.navigateTo(ShopPage.orders),
        ),
        _NavButton(
          label: 'Profil',
          icon: Icons.person_rounded,
          active: pageHandler.currentPage == ShopPage.profile,
          onTap: () => pageHandler.navigateTo(ShopPage.profile),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: _NavButton(
            label: 'Varukorg',
            icon: Icons.shopping_cart_rounded,
            active: cartActive,
            onTap: () => pageHandler.navigateTo(ShopPage.cart),
            badgeCount: cartCount,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(PageHandler pageHandler) {
    if (pageHandler.currentPage == ShopPage.shop) {
      final category = pageHandler.selectedCategory;
      if (category == dealsCategoryId) {
        return const DealsPage();
      }
      if (category != null) {
        return CategoryPage(categoryId: category);
      }
      return const StorePage();
    }

    switch (pageHandler.currentPage) {
      case ShopPage.cart:
        return const CartPage();
      case ShopPage.checkout:
        return const CheckoutPage();
      case ShopPage.recipes:
        return const RecipesPage();
      case ShopPage.orders:
        return const OrdersPage();
      case ShopPage.profile:
        return const ProfilePage();
      default:
        return const StorePage();
    }
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovering = false;

  Color get _backgroundColor {
    if (widget.active) return Colors.white24;
    if (_hovering) return Colors.white.withValues(alpha: 0.22);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.badgeCount > 0
        ? Badge(
            isLabelVisible: true,
            label: Text('${widget.badgeCount}'),
            child: Icon(widget.icon, color: Colors.white, size: 18),
          )
        : Icon(widget.icon, color: Colors.white, size: 18);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton.icon(
            onPressed: widget.onTap,
            icon: icon,
            label: Text(
              widget.label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}
