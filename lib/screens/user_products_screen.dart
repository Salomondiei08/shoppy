import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

import '../helpers/routes.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(filterProducts: true);
  }

  @override
  Widget build(BuildContext context) {
   
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
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapShot.connectionState == ConnectionState.none) 
            {

              return const Center(
                child: Text("Vous n'avez aucun produit"));
            }
            else {
              return Consumer<ProductsProvider>(
                builder: (ctx, products, _) => RefreshIndicator(
                  onRefresh: () async {
                    _refreshProducts(context);
                  },
                  child: ListView.separated(
                    separatorBuilder: (_, i) => const Divider(),
                    itemCount: products.allProducts.length,
                    itemBuilder: (ctx, i) => UserProductItem(
                      id: products.allProducts[i].id,
                      title: products.allProducts[i].title,
                      imageUrl: products.allProducts[i].imageUrl,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
