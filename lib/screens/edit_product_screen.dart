import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNNode.addListener(_upadateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // final productId = ModalRoute.of(context)!.settings.arguments as String;
    // if (productId.isEmpty){
    //   return;
    // }
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _upadateImageUrl() {
    if (_imageUrlController.text.isEmpty) {
      return setState(() {});
    }
    if (!_imageUrlFocusNNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNNode.removeListener(_upadateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future <void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
       _isLoading = true;
    });
   
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      } catch (error){
         await showDialog(context: context, 
            builder: (context) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong!'),
                actions: [
                  TextButton(onPressed: () {
                       Navigator.of(context).pop();
                  }, child: Text('Okay'))
                ],
            ),
            );
      } 
      // finally {
      //       setState(() {
      //         _isLoading = false;
      //       });
      //     Navigator.of(context).pop();
      // }
    }
     setState(() {
              _isLoading = false;
            });
          Navigator.of(context).pop();
   
    //  print(_editedProduct.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) 
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value as String,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.tryParse(value)! <= 0) {
                        return 'Please enter a number greater than zero';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value as String),
                          imageUrl: _editedProduct.imageUrl);
                    }),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      description: value as String,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please eneter a description.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _initValues['image'],
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        focusNode: _imageUrlFocusNNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value as String,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http')) {
                            return 'Please enter a valid URL.';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
