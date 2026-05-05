import 'package:flutter/material.dart';
import 'package:imat/Pages/shop_scaffold.dart';
import 'package:imat/model/page_handler.dart';
import 'package:provider/provider.dart';
 
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageHandler()),
      ],
      child: const MainApp(),
    ),
  );
}
 
class MainApp extends StatelessWidget {
  const MainApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iMat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ShopScaffold(),
    );
  }
}