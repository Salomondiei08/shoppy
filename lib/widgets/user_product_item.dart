import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/helpers/routes.dart';
import 'package:shoppy/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(
                  context, Routes.editProductScreen,
                  arguments: id),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed'),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
