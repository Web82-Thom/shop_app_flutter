import 'package:flutter/material.dart';

import '../models/product.dart';
//Class du fournisseur qui permet de creer un tunnel pour transmettre les élements avoir acces direct a cette liste
class ProductsProviders with ChangeNotifier {
  //creation d'une liste de mes produits via models/produsts.dart
  List<Product> _items = [];
  //getter
  List<Product> get items {
    return [..._items];
  }
// ajouter un produit
void addProduct(){
  // _items.add(value);
  notifyListeners();
}
  
}