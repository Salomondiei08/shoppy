import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/orders.dart';
import 'package:shoppy/widgets/app_drawer.dart';
import 'package:shoppy/widgets/order_tile.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _futureOrders = getOrders();

  Future getOrders() async {
    return await Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrderItems();
  }
  
  @override
  void initState() {
    _futureOrders = getOrders();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _futureOrders,
            builder: (context, snapData) {
              if (snapData.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapData.error != null) {
                  return AlertDialog(
                    content: const Text("Unable to fetch Data"),
                    title: const Text("Something went xrong"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Got it"))
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderTile(
                      order: orderData.orders[i],
                    ),
                  );
                }
              }
            }),
      ),
    );
  }
}
