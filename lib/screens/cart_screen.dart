import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart.dart';
import 'package:shoppy/providers/orders.dart';
import 'package:shoppy/widgets/cart_tile.dart';

import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isDataLoading = false;
  Future<void> _refreshCart(
      List<CartItem> cartOrderItems, double amount) async {
    setState(() {
      _isDataLoading = true;
    });
    await Provider.of<Orders>(context, listen: false)
        .addOrders(cartOrderItems, amount);

          setState(() {
      _isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  const Spacer(),
                  Chip(
                    backgroundColor: Colors.teal,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                _isDataLoading ? const CircularProgressIndicator() :  TextButton(
                    onPressed: (cart.itemCount < 1)
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Order Notice'),
                                content: const Text(
                                  'Do you want to Order ?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _refreshCart(cart.allCart.values.toList(),
                                          cart.totalAmount);
                                      cart.clearCart();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(
                        color: (cart.itemCount < 1) ? Colors.grey : Colors.teal,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.allCart.length,
              itemBuilder: (ctx, i) => CartTile(
                  title: cart.allCart.values.toList()[i].title,
                  id: cart.allCart.values.toList()[i].id,
                  price: cart.allCart.values.toList()[i].price,
                  quantity: cart.allCart.values.toList()[i].quantity,
                  productId: cart.allCart.keys.toList()[i]),
            ),
          )
        ],
      ),
    );
  }
}
