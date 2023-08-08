import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.black),
    );
  }
}

class TitleWhiteText extends StatelessWidget {
  const TitleWhiteText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.04,
          color: Colors.white,
          fontWeight: FontWeight.bold),
    );
  }
}

class FavoriteTitleText extends StatelessWidget {
  const FavoriteTitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.03,
          fontWeight: FontWeight.bold,
          color: Colors.black),
    );
  }
}

class MainTitleText extends StatelessWidget {
  const MainTitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.022,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }
}
