import 'package:flutter/material.dart';
import 'package:shoppy/helpers/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
           ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.productOverviewScreen),

          ),
          const Divider(),
           ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () => Navigator.pushNamed(context, Routes.orderScreen),
          ),
        ],
      ),
    );
  }
}
