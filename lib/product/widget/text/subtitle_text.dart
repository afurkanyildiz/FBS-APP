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
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.025,
          color: Colors.white,
          fontWeight: FontWeight.w300),
    );
  }
}

class FavoriteSubtitleText extends StatelessWidget {
  const FavoriteSubtitleText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.titleSmall?.copyWith(color: Colors.black),
      overflow: TextOverflow.clip,
      maxLines: MediaQuery.of(context).size.height < 380 ? 1 : 2,
      softWrap: MediaQuery.of(context).size.height < 380 ? false : true,
    );
  }
}
