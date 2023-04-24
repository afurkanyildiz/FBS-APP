import 'dart:async';
import 'package:firat_bilgisayar_sistemleri/feature/auth/sign_up.dart';
import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/constants/colors.dart';
import '../../product/constants/images.dart';
import '../../product/widget/reusable_widgets.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorConstants.mainbackgroundlinear1,
                ColorConstants.mainbackgroundlinear2
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SignInForm(context)),
    );
  }

  SingleChildScrollView SignInForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.20, 20, 0),
        child: SignInFormColumn(context),
      ),
    );
  }

  Column SignInFormColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        logoWidget(ImageConstants.appLogo.toPng),
        SizedBox(height: 30),
        reusableTextField("Email Adresini Giriniz", Icons.person_outline, false,
            _emailTextController),
        SizedBox(height: 30),
        reusableTextField(
            "Sifre Giriniz", Icons.lock_outline, true, _passwordTextController),
        SizedBox(height: 20),
        signInSignUpButton(context, true, () {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailTextController.text,
                  password: _passwordTextController.text)
              .then((value) {
            Navigator.pushReplacement(
                context,
                // ignore: inference_failure_on_instance_creation
                MaterialPageRoute(builder: (context) => OrientationPage()));
          }).onError((error, stackTrace) {
            print("Error ${error.toString()}");
          });
        }),
        signUpOption()
      ],
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hesabınız Yok Mu?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                // ignore: inference_failure_on_instance_creation
                MaterialPageRoute(builder: (context) => const SignUp()));
          },
          child: Text(
            " Kayıt Ol",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
