import 'package:flutter/material.dart';
import 'package:shoppy/screens/product_detail_screen.dart';
import 'package:shoppy/screens/product_overview_screen.dart';

String productOverviewScreen = '/';
String productDetailScreen = '/ProductDetailScreen';

Map<String, Widget Function(BuildContext)> routes = {

productOverviewScreen : (context) => const ProductOverviewScreen(),
productDetailScreen : (context) => const ProductDetailScreen()

};
