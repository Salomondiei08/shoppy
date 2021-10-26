import 'package:flutter/material.dart';

import 'helpers/routes.dart' as route_provider;

void main() {
  runApp(const ShoppyApp());
}

class ShoppyApp extends StatelessWidget {
  const ShoppyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // secondaryColor: Colors.blue
      ),
      title: 'Shoppy',
      routes: route_provider.routes,
      initialRoute: route_provider.productOverviewScreen,
    );
  }
}
