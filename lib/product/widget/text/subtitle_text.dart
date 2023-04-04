import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SubTitleText extends StatelessWidget {
  const SubTitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.titleSmall?.copyWith(color: Colors.black),
    );
  }
}

class SubTitleWhiteText extends StatelessWidget {
  const SubTitleWhiteText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.titleSmall?.copyWith(color: Colors.white),
    );
  }
}
