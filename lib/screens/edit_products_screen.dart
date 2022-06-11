import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  final _textFocusNode = FocusNode();

  final _urlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isWidgetInit = true;
  bool _isLoading = false;

  var _editedProduct =
      Product(id: '', description: '', imageUrl: '', title: '', price: 0);

  Map<String, String> initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _urlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isWidgetInit) {
      try {
        final productId = ModalRoute.of(context)!.settings.arguments as String;

        _editedProduct =
            Provider.of<ProductsProvider>(context).findProductById(productId);
        initialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      } catch (e) {
        print(e);
      }
    }
    _isWidgetInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _textFocusNode.dispose();
    _urlFocusNode.dispose();
    _imageUrlController.dispose();
    _urlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();

    if (_isValid) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      if (_editedProduct.id == '') {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
         await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: const Text("Something went wrong"),
              title: const Text("An error occured"),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Okay"))
              ],
            ),
          );
        }
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct, _editedProduct.id);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                          initialValue: initialValues['title'],
                          decoration: const InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: value!,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value!.isEmpty) return "Enter a Title";
                            return null;
                          }),
                      TextFormField(
                        initialValue: initialValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_textFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value!),
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Please Enter a price";
                          if (double.tryParse(value) == null) {
                            return "Please Enter an integer";
                          }
                          if (double.tryParse(value)! <= 0) {
                            return "Please Enter numbre greater than 0";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          initialValue: initialValues['description'],
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          focusNode: _textFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_urlFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: value!,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value!.isEmpty) return "Enter a Description";
                            if (value.length < 10) {
                              return "Should be at least 10 caracter long";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.greenAccent),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(child: Text('Enter a URL'))
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              focusNode: _urlFocusNode,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: value!,
                                    price: _editedProduct.price,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              validator: (value) {
                                if (value!.isEmpty) return "Enter an URL";
                                return null;
                              }),
                        )
                      ])
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _updateImageUrl() {
    if (!_urlFocusNode.hasFocus) {
      setState(() {});
    }
  }
}
