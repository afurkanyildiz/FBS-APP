import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firat_bilgisayar_sistemleri/feature/splash/splash_provider.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/wavy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/images.dart';
import '../home/home.dart';
import '../wrapper.dart';

class SplashViewState extends ConsumerStatefulWidget {
  const SplashViewState({super.key});

  @override
  ConsumerState<SplashViewState> createState() => _SplashViewStateState();
}

class _SplashViewStateState extends ConsumerState<SplashViewState> {
  final splashProvider = StateNotifierProvider<SplashProvider, SplashState>(
    (ref) {
      return SplashProvider();
    },
  );

  @override
  void initState() {
    super.initState();
    ref.read(splashProvider.notifier).checkApplicationVersion(''.version);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashProvider, (previous, next) {
      if (next.isRequiredForceUpdate ?? false) {
        showAboutDialog(context: context);
        return;
      }

      if (next.isRedirectHome != null) {
        if (next.isRedirectHome!) {
          context.navigateToPage(OrientationPage());
        } else {
          //false
        }
      }
    });
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.appLogo.toPng),
            WavyBoldText(title: StringConstants.appName)
          ],
        ),
      ),
    );
  }
}
