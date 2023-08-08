import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:firat_bilgisayar_sistemleri/main.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../feature/auth/sign_in.dart';

void registerUser(
    BuildContext context,
    TextEditingController name,
    TextEditingController username,
    TextEditingController email,
    TextEditingController password) async {
  final _auth = FirebaseAuth.instance;
  try {
    // ignore: omit_local_variable_types
    final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(), password: password.text);

    if (newUser != null) {
      // ignore: omit_local_variable_types
      UserModel user = UserModel(
        id: newUser.user!.uid,
        name: name.text,
        username: username.text,
        email: email.text.trim(),
        password: '',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.user?.uid)
          .set(user.toJson());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  } catch (e) {
    print(e);
  }
}

void signIn(BuildContext context, TextEditingController email,
    TextEditingController password) async {
  final _auth = FirebaseAuth.instance;
  try {
    final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);

    if (user != null) {
      print('Giris Basarili');
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    }
  } catch (e) {
    print(e.toString());
    print('Giris Basarisiz');
  }
}
