import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/padding.dart';

class SmallCardView extends StatelessWidget {
  const SmallCardView({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: listPaddingHorizontal,
      child: GestureDetector(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  color: ColorConstants.chipColor,
                  border: Border.all(width: 2, color: Color(0xffFF8527)),
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: Icon(icon),
                iconSize: MediaQuery.of(context).size.height * 0.03,
                onPressed: () {},
                color: ColorConstants.textfieldWhite,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
