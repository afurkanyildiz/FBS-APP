import 'package:flutter/material.dart';
import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:provider/provider.dart';
import '../product/models/user.dart';
import 'auth/authenticaion_provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    // print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return OrientationPage();
    }
  }
}
