import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../constants/colors.dart';
import '../../constants/padding.dart';

class SmallCardView extends StatelessWidget {
  const SmallCardView({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        child: Column(
          children: [
            Container(
              width: context.dynamicHeight(.06),
              height: context.dynamicHeight(.06),
              decoration: BoxDecoration(
                  color: ColorConstants.chipColor,
                  border: Border.all(width: 2, color: Color(0xffFF8527)),
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: Icon(icon),
                onPressed: () {},
                color: ColorConstants.textfieldWhite,
              ),
            ),
            SizedBox(
              height: context.dynamicHeight(.012),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
