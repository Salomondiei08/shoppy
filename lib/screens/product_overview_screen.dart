import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/widgets/product_item.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shoppy'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),

          child: Consumer<ProductsProvider>(builder: (context, product, child) {
            return GridView.builder(
              itemBuilder: (context, index) {
                return ProductGrid(
                  title: product.allProduct[index].title,
                  imageUrl: product.allProduct[index].imageUrl,
                  isFavorite: product.allProduct[index].isFavorite,
                );
              },
              itemCount: product.productNumber,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                
              ),
            );
          }),
        ));
  }
}
