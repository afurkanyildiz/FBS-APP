import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _firebaseComingUser(User? user) {
    if (user == null) {
      return null;
    } else {
      return Users(uid: user.uid);
    }
  }

  Future signInAnonim() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      print(user!.uid);
      return _firebaseComingUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<Users?> get user {
    return _auth.authStateChanges().map(_firebaseComingUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
