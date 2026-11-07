import 'package:flutter/material.dart';

import 'models/product.dart';
import 'pages/cart_page.dart';
import 'pages/home_page.dart';
import 'pages/product_detail_page.dart';
import 'state/cart.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MiniKatalogApp(cart: CartModel()));
}

class MiniKatalogApp extends StatelessWidget {
  final CartModel cart;

  const MiniKatalogApp({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cart: cart,
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        // Android'de listenin sonuna gelince ekran uzuyormus gibi esneyen efekti kapattim
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          overscroll: false,
        ),
        theme: buildAppTheme(),
        // Sayfa gecislerini named route ile yaptim
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => const HomePage(),
          CartPage.routeName: (_) => const CartPage(),
        },
        // Detay sayfasina urunu route argument olarak gonderiyorum, burada onu alip sayfaya veriyorum
        onGenerateRoute: (settings) {
          if (settings.name == ProductDetailPage.routeName) {
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );
  }
}
