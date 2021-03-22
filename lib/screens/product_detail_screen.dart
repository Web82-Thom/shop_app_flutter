import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
// final String title;

// ProductDetailScreen(this.title);
static const routName = '/detail-du-produit';

  @override
  Widget build(BuildContext context) {
    //extraire id
    final productId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(productId,)
      ),
      
    );
  }
}