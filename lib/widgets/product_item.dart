import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';


class ProductItem extends StatelessWidget {
  // propriété pour afficher un produit
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // ProductItem(this.id, this.title, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    // print(products[1.toInt()]);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector( 
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              // arguments: product.id,
              arguments: product.id,
            );
          },
          child: Image.network(
          //  product.imageUrl,
          //  product.imageUrl,
           product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: GridTileBar(
          title: Text(
            // product.title,
            product.title,
            // product.title,
            textAlign: TextAlign.center,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: IconButton(
            icon: Icon(
              product.isFavorite?
              Icons.favorite: Icons.favorite_border,
            ),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.price.toString() + ' €',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              // product.toggle
            },
            color: Theme.of(context).accentColor,
          ),
          
        ),
      ),
    );
  }
}
