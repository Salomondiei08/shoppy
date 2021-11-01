import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/helpers/routes.dart';
import 'package:shoppy/providers/cart.dart';
import 'package:shoppy/providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, Routes.productDetailScreen, arguments: id),
          child: Image.network(product.findProductById(id).imageUrl,
              fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          title: Text(
            product.findProductById(id).title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () {
              product.setFavorite(id);
            },
            icon: Icon(
                product.findProductById(id).isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(id, product.findProductById(id).price,
                  product.findProductById(id).title);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
