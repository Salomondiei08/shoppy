import 'package:flutter/material.dart';
import 'package:shoppy/helpers/routes.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100, 
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.editProductScreen),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.editProductScreen),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
