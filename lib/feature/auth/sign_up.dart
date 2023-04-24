import 'package:firat_bilgisayar_sistemleri/product/widget/reusable_widgets.dart';
import 'package:firat_bilgisayar_sistemleri/feature/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../product/constants/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repeatPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorConstants.signUpScaffolBackground,
        elevation: 0,
        title: Text(
          "Kayit Ol",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                reusableTextField(
                    "Isim Soyisim", Icons.person_outline, false, _username),
                SizedBox(height: 20),
                reusableTextField(
                    "Email Adresi", Icons.email_outlined, false, _email),
                SizedBox(height: 20),
                reusableTextField(
                    "Şifre Giriniz", Icons.password_outlined, true, _password),
                SizedBox(height: 20),
                reusableTextField("Şifre Tekrar Giriniz",
                    Icons.password_outlined, true, _repeatPassword),
                SizedBox(height: 20),
                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email.text, password: _password.text)
                      .then((value) {
                    print("Created New Account");
                    Navigator.push(
                        context,
                        // ignore: inference_failure_on_instance_creation
                        MaterialPageRoute(
                            builder: (context) => OrientationPage()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
