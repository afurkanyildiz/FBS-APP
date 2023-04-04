import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../constants/colors.dart';
import '../../constants/string.dart';

class WavyBoldText extends StatelessWidget {
  const WavyBoldText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(repeatForever: true, animatedTexts: [
      WavyAnimatedText(
        title,
        textStyle: context.textTheme.headlineSmall?.copyWith(
            color: ColorConstants.textfieldWhite, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
