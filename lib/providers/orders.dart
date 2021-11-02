import 'package:flutter/material.dart';
import 'package:shoppy/models/cart_item.dart';
import 'package:shoppy/models/order_item.dart';

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double amount) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: amount,
        products: cartProducts,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
