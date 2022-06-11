import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

import '../helpers/routes.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).allProduct;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.editProductScreen);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshProducts(context);
        },
        child: ListView.separated(
          separatorBuilder: (_, i) => const Divider(),
          itemCount: products.length,
          itemBuilder: (ctx, i) => UserProductItem(
            id: products[i].id,
            title: products[i].title,
            imageUrl: products[i].imageUrl,
          ),
        ),
      ),
    );
  }
}
