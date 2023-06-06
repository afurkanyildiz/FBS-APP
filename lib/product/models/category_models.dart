import 'package:equatable/equatable.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/base/base_firebase.dart';

class Categories extends Equatable with IdModel, BaseFirebaseModel<Categories> {
  Categories({
    this.categoryName,
    this.imagePath,
    this.id,
  });
  final String? categoryName;
  final String? imagePath;
  final String? id;

  @override
  List<Object?> get props => [categoryName, imagePath, id];

  Categories copyWith({
    String? categoryName,
    String? imagePath,
    String? id,
  }) {
    return Categories(
      categoryName: categoryName ?? this.categoryName,
      imagePath: imagePath ?? this.imagePath,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'image_path': imagePath,
      'id': id,
    };
  }

  @override
  Categories fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryName: json['category_name'] as String?,
      imagePath: json['image_path'] as String?,
      id: json['id'] as String?,
    );
  }
}
