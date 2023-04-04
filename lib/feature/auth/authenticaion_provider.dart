import 'package:firat_bilgisayar_sistemleri/feature/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}

// class AuthenticateNotifier extends StateNotifier<AuthState> {
//   AuthenticateNotifier() : super(AuthState());
// }

// class AuthState {}
