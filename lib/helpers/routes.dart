import 'package:flutter/material.dart';
import 'package:shoppy/screens/cart_screen.dart';
import 'package:shoppy/screens/order_screen.dart';
import 'package:shoppy/screens/product_detail_screen.dart';
import 'package:shoppy/screens/product_overview_screen.dart';
import 'package:shoppy/screens/user_products_screen.dart';

import '../screens/edit_products_screen.dart';

abstract class Routes {
  static const String productOverviewScreen = '/';
  static const String productDetailScreen = '/ProductDetailScreen';
  static const String cartScreen = '/CartScreen';
  static const String userProductsScreen = '/UserProductsScreen';
  static const String orderScreen = '/OrderScreen';
  static const String editProductScreen = '/EditProductScreen';

  static Map<String, Widget Function(BuildContext)> routesList = {
    productOverviewScreen: (context) => const ProductOverviewScreen(),
    productDetailScreen: (context) => const ProductDetailScreen(),
    cartScreen: (context) => const CartScreen(),
    userProductsScreen: (context) => const UserProductsScreen(),
    orderScreen: (context) => const OrderScreen(),
    editProductScreen: (context) => const EditProductScreen(),
  };

  static Route onGenerateGoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case productOverviewScreen:
        return MaterialPageRoute(
            builder: (ctx) => const ProductOverviewScreen());

      case productDetailScreen:
        return MaterialPageRoute(builder: (ctx) => const ProductDetailScreen());

      case cartScreen:
        return MaterialPageRoute(builder: (ctx) => const OrderScreen());

      case orderScreen:
        return MaterialPageRoute(
            builder: (ctx) => const ProductOverviewScreen());

      case userProductsScreen:
        return MaterialPageRoute(builder: (ctx) => const UserProductsScreen());

      default:
        return MaterialPageRoute(
            builder: (ctx) => const ProductOverviewScreen());
    }
  }
}
