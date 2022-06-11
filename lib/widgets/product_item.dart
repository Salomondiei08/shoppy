import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/helpers/routes.dart';
import 'package:shoppy/providers/cart.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gaimon/gaimon.dart';

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
          onTap: () => Navigator.pushNamed(context, Routes.productDetailScreen,
              arguments: id),
          child: CachedNetworkImage(
              placeholder: ((context, url) => const Text('Image Looading')),
              imageUrl: product.findProductById(id).imageUrl,
              fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          title: Text(
            product.findProductById(id).title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () async {
              try {
                await product.setFavorite(id);
              } catch (e) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Can't set favorite")));
              }
            },
            icon: Icon(
                product.findProductById(id).isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: IconButton(
            onPressed: () {
              Gaimon.selection();
              cart.addItem(id, product.findProductById(id).price,
                  product.findProductById(id).title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${product.findProductById(id).title} Added to the cart'),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(id);
                        Gaimon.selection();
                      }),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
