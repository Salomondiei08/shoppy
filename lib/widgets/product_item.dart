import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/helpers/routes.dart';
import 'package:shoppy/providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.isFavorite,
      required this.id})
      : super(key: key);
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, productDetailScreen, arguments: id),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () {
              product.setFavorite(id);
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor),
          ),
          trailing: IconButton(
            
            onPressed: () {},
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
