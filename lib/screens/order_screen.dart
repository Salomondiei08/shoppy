import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/orders.dart';
import 'package:shoppy/widgets/app_drawer.dart';
import 'package:shoppy/widgets/order_tile.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => OrderTile(
              order: orderData.orders[i],
            ),
          ),
        ));
  }
}
