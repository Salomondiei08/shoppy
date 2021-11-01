import 'package:flutter/material.dart';
import 'package:shoppy/screens/cart_screen.dart';
import 'package:shoppy/screens/product_detail_screen.dart';
import 'package:shoppy/screens/product_overview_screen.dart';

class Routes {


static const String productOverviewScreen = '/';
static const String productDetailScreen = '/ProductDetailScreen';
static const String cartScreen = '/CartScreen';

static Map<String, Widget Function(BuildContext)> routesList = {

productOverviewScreen : (context) => const ProductOverviewScreen(),
productDetailScreen : (context) => const ProductDetailScreen(),
cartScreen : (context) => const CartScreen()

};
}

