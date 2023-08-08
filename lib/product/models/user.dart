import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  final String id;
  final String name;
  final String username;
  final String email;
  final String password;

  List<Object?> get props => [id, name, username, email, password];

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
