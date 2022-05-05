import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).allProduct;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: ListView.separated(
        separatorBuilder: (_, i) => const Divider(),
        itemCount: products.length,
        itemBuilder: (ctx, i) => UserProductItem(
          title: products[i].title,
          imageUrl: products[i].imageUrl,
        ),
      ),
    );
  }
}
