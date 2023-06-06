import 'package:equatable/equatable.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/base/base_firebase.dart';

class Products extends Equatable with IdModel, BaseFirebaseModel<Products> {
  Products({
    this.productName,
    this.productExplanation,
    this.imagePath,
    this.categories,
    this.price,
    this.rating,
    this.quantity,
    required this.stock,
    this.id,
  });
  final String? productName;
  final String? productExplanation;
  final String? imagePath;
  final String? categories;
  final double? price;
  final double? rating;
  final int? quantity;
  final int stock;
  final String? id;

  @override
  // TODO: implement props
  List<Object?> get props => [
        productName,
        productExplanation,
        imagePath,
        categories,
        price,
        rating,
        quantity,
        stock,
        id
      ];

  Products copyWith({
    String? productName,
    String? productExplanation,
    String? imagePath,
    String? categories,
    double? price,
    double? rating,
    int? quantity,
    int? stock,
    String? id,
  }) {
    return Products(
      productName: productName ?? this.productName,
      productExplanation: productExplanation ?? this.productExplanation,
      imagePath: imagePath ?? this.imagePath,
      categories: categories ?? this.categories,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_explanation': productExplanation,
      'imagePath': imagePath,
      'categories': categories,
      'price': price,
      'rating': rating,
      'quantity': quantity,
      'stock': stock,
      'id': id,
    };
  }

  Products fromJson(Map<String, dynamic> json) {
    return Products(
      productName: json['product_name'] as String?,
      productExplanation: json['product_explanation'] as String?,
      imagePath: json['imagePath'] as String?,
      categories: json['categories'] as String?,
      price: json['price'] == null
          ? null
          : double.tryParse(json['price'].toString()),
      // rating: json['rating'] as String?,
      rating: json['rating'] == null
          ? null
          : double.tryParse(json['rating'].toString()),
      quantity: json['quantity'] == null
          ? null
          : int.tryParse(json['quantity'].toString()),
      stock: json['stock'] == null ? 0 : int.parse(json['stock'].toString()),
      id: json['id'] as String?,
    );
  }
}
