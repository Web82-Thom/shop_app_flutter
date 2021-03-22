import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  //propriété pour afficher un produit
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  ProductItem(this.id, this.title, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        header: GridTileBar(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: IconButton(
            icon: Icon(
              Icons.favorite,
            ),
            onPressed: () {
              /////
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            price.toString() + ' €',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              //...
            },
            color: Theme.of(context).accentColor,
          ),
          
        ),
      ),
    );
  }
}
