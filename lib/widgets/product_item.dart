import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.isFavorite})
      : super(key: key);

  final String title;
  final String imageUrl;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imageUrl, fit: BoxFit.cover),
      footer: GridTileBar(
        title: Text(title),
        backgroundColor: Colors.black54,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.local_movies),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.event_busy),
        ),
      ),
    );
  }
}
