import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppy/models/cart_item.dart';
import 'package:shoppy/models/order_item.dart';
import 'package:http/http.dart' as http;

import '../helpers/constants.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String? authToken;
  final String? userId;
  Orders(this.authToken, this._orders, this.userId);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartOrderItems, double amount) async {
    final url = Uri.parse(apiBaseUrl + "orders/$userId.json?auth=$authToken");

    final date = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': amount,
          'products': cartOrderItems
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price
                  })
              .toList(),
          'date': date.toIso8601String()
        }),
      );

      final newProduct = json.decode(response.body);
      final id = newProduct['name'];
      final newOrder = OrderItem(
        id: id,
        amount: amount,
        products: cartOrderItems,
        date: date,
      );
      _orders.add(newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> fetchAndSetOrderItems() async {
    final url = Uri.parse(apiBaseUrl + "orders/$userId.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final dynamic extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrderItems = [];
      extractedData.forEach((ordID, ordData) {
        loadedOrderItems.add(
          OrderItem(
            id: ordID,
            amount: ordData['amount'],
            date: DateTime.parse(ordData['date']),
            products: (ordData['products'] as List<dynamic>)
                .map((order) => CartItem(
                    id: order['id'],
                    title: order['title'],
                    price: order['price'],
                    quantity: order['quantity']))
                .toList(),
          ),
        );
      });
      _orders = loadedOrderItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('Une erreue est survenue : $error');
    }
  }
}
