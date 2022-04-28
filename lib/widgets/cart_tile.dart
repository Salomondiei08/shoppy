import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart.dart';

class CartTile extends StatelessWidget {
  const CartTile(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.productId})
      : super(key: key);

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).deleteItem(productId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        child: const Icon(Icons.delete, color: Colors.white),
        color: Theme.of(context).errorColor,
      ),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you sure'),
          content: const Text('DO you want to delete thid item ?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            )
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: ListTile(
          title: Text(title),
          subtitle: Text('Total : ${quantity * price}'),
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
          ),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
