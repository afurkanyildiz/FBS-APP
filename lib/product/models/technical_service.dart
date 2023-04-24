import 'package:equatable/equatable.dart';

import '../utility/base/base_firebase.dart';

class TechnicalService extends Equatable
    with IdModel, BaseFirebaseModel<TechnicalService> {
  TechnicalService({
    this.username,
    this.email,
    this.telephoneNumber,
    this.country,
    this.city,
    this.productBrand,
    this.productModel,
    this.date,
    this.address,
    this.complaint,
    this.state,
    this.id,
  });

  final String? username;
  final String? email;
  final String? telephoneNumber;
  final String? country;
  final String? city;
  final String? productBrand;
  final String? productModel;
  final String? date;
  final String? address;
  final String? complaint;
  final String? state;
  @override
  final String? id;

  @override
  List<Object?> get props => [
        username,
        email,
        telephoneNumber,
        country,
        city,
        productBrand,
        productModel,
        date,
        address,
        complaint,
        state,
        id
      ];

  TechnicalService copyWith({
    String? username,
    String? email,
    String? telephoneNumber,
    String? country,
    String? city,
    String? productBrand,
    String? productMode,
    String? date,
    String? address,
    String? complaint,
    String? state,
    String? id,
  }) {
    return TechnicalService(
      username: username ?? this.username,
      email: email ?? this.email,
      telephoneNumber: telephoneNumber ?? this.telephoneNumber,
      country: country ?? this.country,
      city: city ?? this.city,
      productBrand: productBrand ?? this.productBrand,
      productModel: productMode ?? this.productModel,
      date: date ?? this.date,
      address: address ?? this.address,
      complaint: complaint ?? this.complaint,
      state: state ?? this.state,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'telephone_number': telephoneNumber,
      'country': country,
      'city': city,
      'product_brand': productBrand,
      'product_mode': productModel,
      'date': date,
      'address': address,
      'complaint': complaint,
      'state': state,
      'id': id,
    };
  }

  @override
  TechnicalService fromJson(Map<String, dynamic> json) {
    return TechnicalService(
      username: json['username'] as String?,
      email: json['email'] as String?,
      telephoneNumber: json['telephoneNumber'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      productBrand: json['productBrand'] as String?,
      productModel: json['productModel'] as String?,
      date: json['date'] as String?,
      address: json['address'] as String?,
      complaint: json['complaint'] as String?,
      state: json['state'] as String?,
      id: json['id'] as String?,
    );
  }
}
