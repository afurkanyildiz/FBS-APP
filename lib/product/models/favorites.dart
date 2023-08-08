import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesItem {
  final Products product;

  FavoritesItem({required this.product});

  String? get imagePath {
    return product.imagePaths?.first;
  }

  String? get productName {
    return product.productName;
  }

  double? get price {
    return product.price;
  }

  int? get total_rating {
    return product.total_rating;
  }

  int? get total_votes {
    return product.total_votes;
  }

  int get stock {
    return product.stock;
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson()};
  }

  factory FavoritesItem.fromJson(Map<String, dynamic> json) {
    final productData = json['product'] as Map<String, dynamic>;
    return FavoritesItem(
        product: Products(
      stock: productData['stock'] == null
          ? 0
          : int.tryParse(productData['stock'].toString())!,
    ).fromJson(productData));
  }
}

class Favorites extends ChangeNotifier {
  List<FavoritesItem> _items = [];
  Favorites({List<FavoritesItem> initialItems = const []}) {
    _items = initialItems;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      loadFavoritesFromFirestore().then((pageItems) {
        _items = pageItems;
        notifyListeners();
        // ignore: inference_failure_on_untyped_parameter
      }).catchError((error) {
        print('Hata: $error');
      });
    }
  }

  List<FavoritesItem> get items => _items;

  bool isFavorite(Products product) {
    return _items.any((item) => item.product.id == product.id);
  }

  void toogleFavorite(Products product) {
    if (isFavorite(product)) {
      final favoriteItem =
          _items.firstWhere((item) => item.product.id == product.id);
      removeFromFavoritesPage(favoriteItem);
    } else {
      addToFavoritesPage(FavoritesItem(product: product));
    }
  }

  Future<void> addToFavoritesPage(FavoritesItem item) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final product = item.product;
      final user = FirebaseAuth.instance.currentUser;
      final pageCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('favorites');

      final pageItemDoc = pageCollection.doc(product.id);
      final pageItemDocSnapshot = await pageItemDoc.get();

      if (pageItemDocSnapshot.exists) {
        final existingItem = FavoritesItem.fromJson(
            pageItemDocSnapshot.data() as Map<String, dynamic>);
        // ignore: unused_local_variable
        final index = _items
            .indexWhere((item) => item.product.id == existingItem.product.id);
        // _items[index] = item;
      } else {
        pageItemDoc.set(item.toJson());
        _items.add(item); // Yeni favori ürününü ekle
        print('ButtonPressed');
      }
      notifyListeners();
      await updatePageInFirestore();
      // _items = await loadFavoritesFromFirestore();
    } else {
      print('User is not logged in');
    }
  }

  Future<void> removeFromFavoritesPage(FavoritesItem item) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      final pageCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('favorites');

      final pageItemDoc = pageCollection.doc(item.product.id);
      final pageItemDocSnapshot = await pageItemDoc.get();

      if (pageItemDocSnapshot.exists) {
        pageItemDoc.delete();
        _items.removeWhere((element) => element.product.id == item.product.id);
        print('Favorite Product is Delete');
        notifyListeners();
      }
    } else {
      print('User is not logged in');
    }
  }

  StreamSubscription<QuerySnapshot>? _favoritesSubscription;

  void startListeningToFirestore() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pageCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      _favoritesSubscription = pageCollection.snapshots().listen((snapshot) {
        // ignore: unused_local_variable
        final updatedItems = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final productData = data['product'] as Map<String, dynamic>;
          final product = Products(
            stock: productData['stock'] == null
                ? 0
                : int.tryParse(productData['stock'].toString())!,
          ).fromJson(productData);

          return FavoritesItem(product: product);
        }).toList();

        // _items.clear();
        // items.addAll(updatedItems); // Yalnızca güncel verileri ekleyin
        notifyListeners();
      });
    }
  }

  void stopListeningToFirestore() {
    _favoritesSubscription?.cancel();
  }

  Future<void> updatePageInFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pageCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      await pageCollection.get().then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      for (final item in _items) {
        pageCollection.doc(item.product.id).set(item.toJson());
      }
    }
  }

  Future<List<FavoritesItem>> loadFavoritesFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pageCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final snapshot = await pageCollection.get();
      final pageItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final productData = data['product'] as Map<String, dynamic>;
        final product = Products(
          stock: productData['stock'] == null
              ? 0
              : int.tryParse(productData['stock'].toString())!,
        ).fromJson(productData);

        return FavoritesItem(product: product);
      }).toList();

      final List<FavoritesItem> newItems = [];
      for (final newItem in pageItems) {
        final existingItem = _items.indexWhere(
          (item) => item.product.id == newItem.product.id,
        );

        if (existingItem != -1) {
          _items[existingItem] = newItem;
        } else {
          newItems.add(newItem);
        }
      }

      _items = List.from(_items)..addAll(newItems);
      // _items.addAll(newItems);
      _items.removeWhere((item) =>
          pageItems
              .indexWhere((newItem) => newItem.product.id == item.product.id) ==
          -1);
      notifyListeners();

      return pageItems;
    }
    return [];
  }
}
