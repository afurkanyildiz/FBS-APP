// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SmallTitleText extends StatelessWidget {
  const SmallTitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.headlineSmall
          ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}
