import 'package:flutter/material.dart';
import 'package:shoppy/screens/product_overview_screen.dart';

String productOverviewScreen = '/';

Map<String, Widget Function(BuildContext)> routes = {

productOverviewScreen : (context) => const ProductOverviewScreen()

};
