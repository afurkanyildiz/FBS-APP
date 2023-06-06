import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:flutter/material.dart';

class CartItem {
  final Products product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  String? get imagePath {
    return product.imagePath;
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
}

class Cart extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return items.fold(
        0,
        (double sum, cartItem) =>
            sum + (cartItem.price ?? 0) * cartItem.quantity);
  }

  void addToCart(CartItem item) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.product == item.product,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  void removeFromCart(Products product) {
    CartItem? foundItem;
    for (CartItem item in items) {
      if (item.product.id == product.id) {
        foundItem = item;
        break;
      }
    }
    if (foundItem != null) {
      items.remove(foundItem);
      notifyListeners();
    }
  }

  void increaseQuantity(CartItem cartItem) {
    final stock = cartItem.product.stock;
    if (stock != null && cartItem.quantity < stock) {
      cartItem.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      notifyListeners();
    }
  }
}
