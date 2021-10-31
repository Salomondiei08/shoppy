import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

import 'helpers/routes.dart' as route_provider;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: const ShoppyApp(),
    ),
  );
}

class ShoppyApp extends StatelessWidget {
  const ShoppyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(secondary: Colors.purple),
          fontFamily: 'Lato'
          // secondaryColor: Colors.blue
          ),
      title: 'Shoppy',
      routes: route_provider.routes,
      initialRoute: route_provider.productOverviewScreen,
    );
  }
}
