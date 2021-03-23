import 'package:flutter/foundation.dart';
// import '../providers/cart.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

}

class Cart with ChangeNotifier {
  //ici on gere les articles du panier
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }
  //affichage du nombre d'article dans la panier
  int get itemCount {
    return _items.length;
  }

  // methode pour le Total
  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  //methode add product
  void addItem(
    String productId, 
    double price, 
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity
      _items.update(
        productId, 
        (existingCartItem) => 
        CartItem(
          id: existingCartItem.id, 
          title: existingCartItem.title, 
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1, 
        ),
      );
    } else {
      _items.putIfAbsent(
        productId, () => CartItem(
          id: DateTime.now().toString(), 
          title: title, 
          price: price,
          quantity: 1,
        ), 
      );
    }
    notifyListeners();
  }

  //delete du panier
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //Effacer apres la commande
  void clear() {
    _items = {};
    notifyListeners(); 
  }
}