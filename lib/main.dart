import 'package:firat_bilgisayar_sistemleri/feature/auth/sign_in.dart';
import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/initialize/application_start.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/cart.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Cart>(create: (_) => Cart()),
    ChangeNotifierProvider<Favorites>(create: (_) => Favorites())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final User? user = snapshot.data;
                return user != null ? OrientationPage() : SignIn();
              } else {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            }));
  }
}
