import 'package:flutter/material.dart';
import 'package:imat/Pages/cart_page.dart';
import 'package:imat/Pages/category_page.dart';
import 'package:imat/Pages/favourites_page.dart';
import 'package:imat/Pages/home_page.dart';
import 'package:imat/Pages/recipes_page.dart';
import 'package:imat/Pages/store.dart';
import 'package:imat/model/page_handler.dart';
import 'package:imat/model/store_stock.dart';
import 'package:provider/provider.dart';

class ShopScaffold extends StatelessWidget {
  const ShopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();
    final stock = context.watch<StoreStock>();
    final isHome = pageHandler.currentPage == ShopPage.home;

    // On the home page we show a full-screen welcome with no nav chrome.
    if (isHome) {
      return const HomePage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF2),
      appBar: _buildAppBar(context, pageHandler, stock),
      body: _buildBody(pageHandler),
      //bottomNavigationBar: _buildBottomNav(context, pageHandler, stock),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
      BuildContext context, PageHandler pageHandler, StoreStock stock) {
    return AppBar(
      backgroundColor: const Color(0xFF1d8a3c),
      foregroundColor: Colors.white,
      elevation: 2,
      titleSpacing: 16,
      title: GestureDetector(
        onTap: () => pageHandler.navigateTo(ShopPage.home),
        child: const Text(
          'iMat',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      actions: [
        // Handla
        _NavButton(
          label: 'Handla',
          icon: Icons.store_rounded,
          active: pageHandler.currentPage == ShopPage.shop,
          onTap: () {
            pageHandler.clearCategory();
            pageHandler.navigateTo(ShopPage.shop);
          },
        ),
        // Recept
        _NavButton(
          label: 'Recept',
          icon: Icons.restaurant_menu_rounded,
          active: pageHandler.currentPage == ShopPage.recipes,
          onTap: () => pageHandler.navigateTo(ShopPage.recipes),
        ),
        // Favoriter
        _NavButton(
          label: 'Favoriter',
          icon: Icons.favorite_rounded,
          active: pageHandler.currentPage == ShopPage.favorites,
          onTap: () => pageHandler.navigateTo(ShopPage.favorites),
        ),
        // Cart with badge
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: TextButton.icon(
            onPressed: () => pageHandler.navigateTo(ShopPage.cart),
            icon: Badge(
              isLabelVisible: stock.cartCount > 0,
              label: Text('${stock.cartCount}'),
              child: const Icon(Icons.shopping_cart_rounded,
                  color: Colors.white, size: 22),
            ),
            label: const Text('Varukorg',
                style: TextStyle(color: Colors.white, fontSize: 15)),
            style: TextButton.styleFrom(
              backgroundColor: pageHandler.currentPage == ShopPage.cart
                  ? Colors.white24
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(PageHandler pageHandler) {
    // Shop page: either category view or the main store
    if (pageHandler.currentPage == ShopPage.shop) {
      final cat = pageHandler.selectedCategory;
      if (cat != null) {
        return CategoryPage(category: cat);
      }
      return const Store();
    }

    switch (pageHandler.currentPage) {
      case ShopPage.favorites:
        return const FavouritesPage();
      case ShopPage.cart:
        return const CartPage();
      case ShopPage.recipes:
        return const RecipesPage();
      case ShopPage.account:
        return const Center(
          child: Text('Profil – kommer snart',
              style: TextStyle(fontSize: 20, color: Colors.black45)),
        );
      default:
        return const Store();
    }
  }

  // ── Bottom nav (compact screens) ─────────────────────────────────────────
/*
  Widget _buildBottomNav(
      BuildContext context, PageHandler pageHandler, StoreStock stock) {
    // Hide bottom nav on wide screens (the app bar handles nav there)
    return LayoutBuilder(builder: (context, constraints) {
      // BottomNavigationBar is only useful on narrow screens.
      // On web/desktop the top AppBar suffices.
      return BottomNavigationBar(
        currentIndex: _bottomIndex(pageHandler.currentPage),
        onTap: (i) => pageHandler.navigateTo(_shopPageFromIndex(i)),
        selectedItemColor: const Color(0xFF1d8a3c),
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.store_rounded), label: 'Handla'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_rounded), label: 'Recept'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: stock.cartCount > 0,
              label: Text('${stock.cartCount}'),
              child: const Icon(Icons.shopping_cart_rounded),
            ),
            label: 'Varukorg',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: 'Favoriter'),
        ],
      );
    });
  }

  int _bottomIndex(ShopPage page) {
    switch (page) {
      case ShopPage.shop:
        return 0;
      case ShopPage.recipes:
        return 1;
      case ShopPage.cart:
        return 2;
      case ShopPage.favorites:
        return 3;
      default:
        return 0;
    }
  }

  ShopPage _shopPageFromIndex(int i) {
    switch (i) {
      case 0:
        return ShopPage.shop;
      case 1:
        return ShopPage.recipes;
      case 2:
        return ShopPage.cart;
      case 3:
        return ShopPage.favorites;
      default:
        return ShopPage.shop;
    }
  }
}
*/
}
// ── Small helper widget ───────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        style: TextButton.styleFrom(
          backgroundColor:
              active ? Colors.white24 : Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );
  }
}
