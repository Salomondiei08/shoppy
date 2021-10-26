import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';


class ProductOverviewScreen extends StatefulWidget {
 const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoppy'),),

      body: Consumer<ProductsProvider>(
        builder: (context, product, child) {  },
        child: GridView.builder(itemBuilder: (context, index) {
          return Card()
        }, gridDelegate: SliverG,),
      )
    );
  }
}