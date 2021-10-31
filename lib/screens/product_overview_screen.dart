import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/widgets/product_item.dart';

enum FilterOptions { all, onlyFavorites }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

   bool _showFavorite = false;
  @override
  Widget build(BuildContext context) {
   

    void _setFilterOptions(FilterOptions filterOption) {
      setState(() {
        if (filterOption == FilterOptions.all) {
          _showFavorite = false;
        } else {
          _showFavorite = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoppy'),
        actions: [
          PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: _setFilterOptions,
            tooltip: 'Options',
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
              const PopupMenuItem(
                child: Text('Show Only Favorites'),
                value: FilterOptions.onlyFavorites,
              )
            ],
          )
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, product, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemBuilder: (context, index) {
                return ProductGrid(
                  title: _showFavorite
                      ? product.favoriteProduct[index].title
                      : product.allProduct[index].title,
                  imageUrl: _showFavorite
                      ? product.favoriteProduct[index].imageUrl
                      : product.allProduct[index].imageUrl,
                  isFavorite: _showFavorite
                      ? product.favoriteProduct[index].isFavorite
                      : product.allProduct[index].isFavorite,
                  id: _showFavorite
                      ? product.favoriteProduct[index].id
                      : product.allProduct[index].id,
                );
              },
              itemCount: _showFavorite
                  ? product.productFavoriteNumber
                  : product.productNumber,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductProvider {}
