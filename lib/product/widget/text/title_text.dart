import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class TitleText extends StatelessWidget {
  const TitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.headlineLarge
          ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
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
      style: context.textTheme.headlineMedium
          ?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
    );
  }
}
