import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart.dart';
import 'package:shoppy/providers/products_provider.dart';

import 'helpers/routes.dart';
import 'providers/orders.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => Cart(),
      ),
      ChangeNotifierProvider(
        create: (context) => Orders(),
      )
    ],
    child: const ShoppyApp(),
  ));
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
      initialRoute: Routes.productOverviewScreen,
      routes: Routes.routesList,
     // onGenerateRoute: Routes.onGenerateGoute,
    );
  }
}
