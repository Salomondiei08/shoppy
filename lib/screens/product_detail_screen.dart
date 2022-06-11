import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context, listen: false);

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(products.findProductById(productId).title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 300,
              width: double.infinity,
              child: CachedNetworkImage(
                  imageUrl: products.findProductById(productId).imageUrl,
                  fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${products.findProductById(productId).price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              products.findProductById(productId).description,
              softWrap: true,
              style: const TextStyle(fontSize: 17, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
