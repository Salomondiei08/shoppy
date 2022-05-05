import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
