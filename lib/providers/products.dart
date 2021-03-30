import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';
//Class du fournisseur qui permet de creer un tunnel pour transmettre les élements avoir acces direct a cette liste
class Products with ChangeNotifier {
  //creation d'une liste de mes produits via models/produsts.dart
  List<Product> _items = [];
  //var qui defini le showFavoritesOnly
  // var _showFavoritesOnly = false;
  //condition pour les favoris
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  // list des favoris
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //retourne un produit par son id
  Product findById (String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
  //methode pour les favoris
  // void showFavoritesOnly (){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  // //methode pour tous les produits
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    const url  = 'https://shop-app-a3f4d-default-rtdb.firebaseio.com/products.json';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) { 
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
      // print(json.decode(response.body));
    } catch (onError) {
      throw (onError);
    }
  }

  // ajouter un produit
  Future<void> addProduct(Product product) async {
   const  url = 'https://shop-app-a3f4d-default-rtdb.firebaseio.com/products.json';
    try { 
      final response = await http.post(
        Uri.parse(url), 
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (onError){
      print('erreur');
      throw onError;
    } 
  }
  //Modifier un produit
  Future<void> updateProduct(String id, Product newProduct)  async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0){
    final  url = 'https://shop-app-a3f4d-default-rtdb.firebaseio.com/products/$id.json';
    await http.patch(Uri.parse(url), body: json.encode({
      'title': newProduct.title,
      'description': newProduct.description,
      'price': newProduct.price,
      'imageUrl': newProduct.imageUrl,
    }),);
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
  // Suppression d'un article
  Future<void> deleteProduct(String id) async {

    final  url = 'https://shop-app-a3f4d-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

      print(response.statusCode);
      
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Impossible de supprimer cette article.');
      }
      existingProduct = null;

      
  }
}