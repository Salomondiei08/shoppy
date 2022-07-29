import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppy/exceptions/http_exceptions.dart';
import 'package:shoppy/models/product.dart';
import 'package:http/http.dart' as http;

import '../helpers/constants.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;

  ProductsProvider(
    this.authToken,
    this._loadedList,
    this.userId,
  );

  List<Product> _loadedList = [];

  List<Product> get allProducts {
    return [..._loadedList];
  }

  List<Product> get favoriteProduct {
    return _loadedList.where((element) => element.isFavorite).toList();
  }

  int get productFavoriteNumber {
    return favoriteProduct.length;
  }

  int get productNumber {
    return allProducts.length;
  }

  Product findProductById(String id) {
    return _loadedList.firstWhere((element) => element.id == id);
  }

  Future<void> setFavorite(String id) async {
    final url = Uri.parse(apiBaseUrl + "products/$id.json?auth=$authToken");

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

  Future<void> fetchAndSetProducts({bool filterProducts = false}) async {

    String filterOption = filterProducts ? '&orderBy="creatorId"&equalTo="$userId"': '';
    try {
      final url = Uri.parse(apiBaseUrl + "products.json?auth=$authToken" + filterOption);
      print("Le token est " + authToken!);
      print("Le token est " + apiBaseUrl + "products.json?auth=$authToken");

      final response = await http.get(url);
      final dynamic extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      if (extractedData["error"] != null) {
        throw HttpException(message: extractedData["error"]);
      }
      print(extractedData);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            description: prodData['description'],
            title: prodData['title'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      print(loadedProducts);
      _loadedList = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('Une erreue est survenue : $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(apiBaseUrl + "products.json?auth=$authToken");

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
            'isFavorite' : product.isFavorite
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
    final url = Uri.parse(apiBaseUrl + "products/$id.json?auth=$authToken");

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
    final url = Uri.parse(apiBaseUrl + "products/$id.json?auth=$authToken");

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
