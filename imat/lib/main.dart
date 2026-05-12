import 'package:flutter/material.dart';
import 'package:imat/model/page_handler.dart';
import 'package:imat/model/store_stock.dart';
import 'package:imat/Pages/shop_scaffold.dart'; // adjust path if needed
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageHandler()),
        ChangeNotifierProvider(create: (_) => StoreStock()),
      ],
      child: MaterialApp(
        title: 'iMat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const ShopScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}