import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final Products product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  String? get imagePath {
    return product.imagePaths?.first;
  }

  String? get productName {
    return product.productName;
  }

  double? get price {
    return product.price;
  }

  int get stock {
    return product.stock;
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productData = json['product'] as Map<String, dynamic>;
    return CartItem(
      product: Products(
        stock: productData['stock'] == null
            ? 0
            : int.tryParse(productData['stock'].toString())!,
      ).fromJson(productData),
      quantity: json['quantity'] as int,
    );
  }
}

class Cart extends ChangeNotifier {
  List<CartItem> _items = [];

  Cart() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      loadCartFromFirestore().then((cartItems) {
        _items = cartItems;
        notifyListeners();
      }).catchError((error) {
        print('Hata: $error');
      });
    }
  }

  List<CartItem> get items => _items;

  double get totalPrice {
    return items.fold(
      0,
      (double sum, cartItem) => sum + (cartItem.price ?? 0) * cartItem.quantity,
    );
  }

  Future<void> addToCart(CartItem item) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final product = item.product;
      final user = FirebaseAuth.instance.currentUser;
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('cart');

      final cartItemDoc = cartCollection.doc(product.id);
      final cartItemDocSnapshot = await cartItemDoc.get();

      if (cartItemDocSnapshot.exists) {
        final existingItem = CartItem.fromJson(
          cartItemDocSnapshot.data() as Map<String, dynamic>,
        );
        final index = _items
            .indexWhere((item) => item.product.id == existingItem.product.id);
        if (index != -1) {
          _items[index].quantity += item.quantity;
          updateCartItemInFirestore(
              _items[index]); // Update the item in Firestore
          notifyListeners();
        }
      } else {
        cartItemDoc.set(item.toJson());
        _items.add(item);
        notifyListeners();
      }

      await updateCartInFirestore(); // Update the cart in Firestore
    } else {
      print('User is not logged in');
    }
  }

  bool isProductInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  Future<void> removeFromCart(Products product) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items.removeAt(index);
      await updateCartInFirestore();
      notifyListeners();
    }
  }

  Future<void> updateCartInFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      await cartCollection.get().then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      for (final item in _items) {
        cartCollection.doc(item.product.id).set(item.toJson());
      }
    }
  }

  void updateCartItemInFirestore(CartItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartItemDoc = cartCollection.doc(item.product.id);
      await cartItemDoc.update({'quantity': item.quantity});
    }
  }

  Future<List<CartItem>> loadCartFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final snapshot = await cartCollection.get();
      final cartItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final productData = data['product'] as Map<String, dynamic>;
        final product = Products(
          stock: productData['stock'] == null
              ? 0
              : int.tryParse(productData['stock'].toString())!,
        ).fromJson(productData);

        return CartItem(product: product, quantity: data['quantity'] as int);
      }).toList();

      return cartItems;
    }
    return [];
  }

  void increaseQuantity(CartItem cartItem) {
    final stock = cartItem.product.stock;
    if (stock != null && cartItem.quantity < stock) {
      cartItem.quantity++;
      updateCartItemInFirestore(cartItem); // Update the item in Firestore
      notifyListeners();
    }
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      updateCartItemInFirestore(cartItem); // Update the item in Firestore
      notifyListeners();
    }
  }
}
