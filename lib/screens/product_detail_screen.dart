import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
// final String title;

// ProductDetailScreen(this.title);
static const routeName = '/detail-du-produit';

  @override
  Widget build(BuildContext context) {
    //extraire id
    final productId = ModalRoute.of(context).settings.arguments as String;
    //appel au fournisseur recuperation des propriétés pars son id
    final loadedProduct = Provider.of<Products>(context, listen: false,).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title,)
      ),
      
    );
  }
}