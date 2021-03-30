import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // ajouter un noeud en memoire
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  // key pour sauvegerder le form
  final _form = GlobalKey<FormState>();
  //sauvegarder les données dans une var 
  var _editProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          // 'imageUrl': _editProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //effacer les neoud
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')
          ) ||
          (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg')
          )
      ) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id !=null) {
      await Provider.of<Products>(context, listen: false).updateProduct(_editProduct.id, _editProduct,);
    } else {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(_editProduct);
      } catch (onError) {
        await showDialog(
          context: context, 
          builder: (ctx) => AlertDialog(
            title: Text('Une erreur s\'est produite'),
            content: Text('Retour page d\'accueil'),
            actions: <Widget>[
              TextButton(child: Text('ok'), onPressed: () {
                print('ok');
                Navigator.of(ctx).pop();
              },),
            ],
          ),
        );
      } 
    }
    setState(() {
      _isLoading = false;
    });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edition d\'un article'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: () {
              _saveForm();
            }),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading 
        ? Center(
          child : CircularProgressIndicator(),
        )
        : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(labelText: 'Titre'),
                textInputAction: TextInputAction.next,
                // permet de changer de zone du formulaire automatiquement
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                    _priceFocusNode,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez remplir le titre';
                  } 
                    return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: value,
                    price: _editProduct.price,
                    description: _editProduct.description,
                    imageUrl: _editProduct.imageUrl,
                    id: _editProduct.id,
                    isFavorite: _editProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                    _descriptionFocusNode,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez remplir le prix';
                  } 
                  if (double.tryParse(value) == null) { 
                    return 'Entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Entrer un nombre superieur à zéro';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: double.parse(value),
                    description: _editProduct.description,
                    imageUrl: _editProduct.imageUrl,
                    id: _editProduct.id,
                  );
                },

              ),
              TextFormField(
                initialValue: _initValue['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez remplir une description';
                  } 
                  if (value.length < 10) {
                    return 'Votre description doit contenir 10 caracteres minimum';
                  }
                    return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: _editProduct.price,
                    description: value,
                    imageUrl: _editProduct.imageUrl,
                    id: _editProduct.id,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Entrer une URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValue['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuillez remplir une image-URL';
                        } 
                        if (!value.startsWith('http') && !value.startsWith('https')) {
                          return "Veuillez remplir une URL valide";
                        }
                        if (!value.endsWith('.png') && !value.endsWith('jpg') && !value.endsWith('.jpeg') ){
                          return "Veuillez remplir une URL-image valide";
                        }
                          return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          price: _editProduct.price,
                          description: _editProduct.description,
                          imageUrl: value,
                          id: _editProduct.id,
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
