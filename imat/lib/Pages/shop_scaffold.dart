
import 'package:flutter/material.dart';
import 'package:imat/model/page_handler.dart';
import 'package:provider/provider.dart';

class ShopScaffold extends StatelessWidget {
  const ShopScaffold({super.key});
 
  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('iMat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => pageHandler.navigateTo(ShopPage.cart),
          ),
        ],
      ),
      body: _buildPage(pageHandler.currentPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageHandler.currentPage.index,
        onTap: (i) => pageHandler.navigateTo(ShopPage.values[i]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
 
  Widget _buildPage(ShopPage page) {
    switch (page) {
      case ShopPage.shop:
        return const Center(child: Text('Shop page — coming soon'));
      case ShopPage.favorites:
        return const Center(child: Text('Favorites — coming soon'));
      case ShopPage.cart:
        return const Center(child: Text('Cart — coming soon'));
      case ShopPage.account:
        return const Center(child: Text('Account — coming soon'));
    }
  }
}