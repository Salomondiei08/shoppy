import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppy/exceptions/http_exceptions.dart';
import 'package:shoppy/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _loadedList = [];

  List<Product> get allProduct {
    return [..._loadedList];
  }

  List<Product> get favoriteProduct {
    return _loadedList.where((element) => element.isFavorite).toList();
  }

  int get productFavoriteNumber {
    return favoriteProduct.length;
  }

  int get productNumber {
    return allProduct.length;
  }

  Product findProductById(String id) {
    return _loadedList.firstWhere((element) => element.id == id);
  }

  Future<void> setFavorite(String id) async {
    final url = Uri.parse(
        "https://shoppy-59758-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");

    Product product = _loadedList.firstWhere((element) => element.id == id);
    final favoriteStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url,
          body: json.encode({'isFavorite': product.isFavorite}));

      if (response.statusCode >= 400) {
        product.isFavorite = favoriteStatus;
        notifyListeners();
      }
    } catch (error) {
      product.isFavorite = favoriteStatus;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final url = Uri.parse(
          "https://shoppy-59758-default-rtdb.europe-west1.firebasedatabase.app/products.json");

      final response = await http.get(url);
      final dynamic extractedData = json.decode(response.body) as Map<String, dynamic>;
       if(extractedData == null){
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _loadedList = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('Une erreue est survenue : $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shoppy-59758-default-rtdb.europe-west1.firebasedatabase.app/products.json");

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));

      final id = json.decode(response.body)['name'];
      final newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _loadedList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(Product newProduct, String id) async {
    final url = Uri.parse(
        "https://shoppy-59758-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");

    final productIndex = _loadedList.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite
          }));
      _loadedList[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shoppy-59758-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");

    final existingProductId =
        _loadedList.indexWhere((element) => element.id == id);

    var exisingElement = _loadedList.elementAt(existingProductId);

    _loadedList.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _loadedList.insert(existingProductId, exisingElement);
      notifyListeners();
      throw HttpException(message: 'Could not delete the product');
    }
  }
}
