import 'package:flutter/material.dart';
import 'package:shoppy/screens/cart_screen.dart';
import 'package:shoppy/screens/order_screen.dart';
import 'package:shoppy/screens/product_detail_screen.dart';
import 'package:shoppy/screens/product_overview_screen.dart';

abstract class Routes {
  static const String productOverviewScreen = '/';
  static const String productDetailScreen = '/ProductDetailScreen';
  static const String cartScreen = '/CartScreen';
  static const String orderScreen = '/OrderScreen';

  static Map<String, Widget Function(BuildContext)> routesList = {
    productOverviewScreen: (context) => const ProductOverviewScreen(),
    productDetailScreen: (context) => const ProductDetailScreen(),
    cartScreen: (context) => const CartScreen(),
    orderScreen: (context) => const OrderScreen(),
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

      default:
        return MaterialPageRoute(
            builder: (ctx) => const ProductOverviewScreen());
    }
  }
}
