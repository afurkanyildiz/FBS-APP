import 'package:equatable/equatable.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/base/base_firebase.dart';

class Products extends Equatable with IdModel, BaseFirebaseModel<Products> {
  Products({
    this.productName,
    this.productExplanation,
    this.productContent,
    this.imagePaths,
    this.technicalDetails,
    this.categories,
    this.price,
    this.rating,
    this.quantity,
    required this.stock,
    this.id,
  });
  final String? productName;
  final String? productExplanation;
  final String? productContent;
  final List<String>? imagePaths;
  final Map<String, dynamic>? technicalDetails;
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
        productContent,
        imagePaths,
        technicalDetails,
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
    String? productContent,
    List<String>? imagePaths,
    Map<String, dynamic>? technicalDetails,
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
      productContent: productContent ?? this.productContent,
      imagePaths: imagePaths ?? this.imagePaths,
      technicalDetails: technicalDetails ?? this.technicalDetails,
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
      'productContent': productContent,
      'imagePaths': imagePaths,
      'technicalDetails': technicalDetails,
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
      productContent: json['productContent'] as String?,

      imagePaths: json['imagePaths'] != null
          ? (json['imagePaths'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : null,
      technicalDetails: json['technicalDetails'] == null
          ? null
          : Map<String, String>.from(
              json['technicalDetails'] as Map<String, dynamic>),
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
