import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/initialize/application_start.dart';
import 'package:firat_bilgisayar_sistemleri/product/service/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await ApplicationStart.init();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider<Cart>(create: (_) => Cart())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return StreamProvider<Users?>.value(
    //   value: AuthService().user,
    //   initialData: null,
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstants.appName,
      home: OrientationPage(),
    );
  }
}
