import 'package:carousel_slider/carousel_slider.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/store_home_view.dart';
import 'package:flutter/material.dart';
import '../../product/constants/colors.dart';
import '../../product/constants/images.dart';
import '../technical-service/technical_service_screen.dart';

class OrientationPage extends StatefulWidget {
  const OrientationPage({super.key});

  @override
  State<OrientationPage> createState() => _OrientationPageState();
}

class _OrientationPageState extends State<OrientationPage>
    with NavigatorManager {
  List<Widget> generaImagesTiles() {
    return imageList
        .map((element) => ClipRRect(
              child: Image.asset(
                element,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItems(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlidersItem(),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: ButtonItems(),
          ),
        ],
      ),
    );
  }

  AppBar AppBarItems() {
    return AppBar(
      title: Text("Fırat Bilgisayar Sistemleri"),
      flexibleSpace: Container(
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
      ),
      actions: [
        MaterialButton(
          child: Icon(Icons.logout, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Stack SlidersItem() {
    return Stack(children: [
      CarouselSlider(
        options: CarouselOptions(
            autoPlay: true, enlargeCenterPage: true, aspectRatio: 18 / 13),
        items: generaImagesTiles(),
      ),
    ]);
  }
}

class ButtonItems extends StatelessWidget with NavigatorManager {
  const ButtonItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Expanded(
          flex: 18,
          child: ElevatedButton.icon(
            onPressed: () {
              navigateToWidget(context, StoreView());
            },
            icon: Icon(Icons.store, size: 40.0),
            label: Text(
              'Magaza',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.apply(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.mainbackgroundlinear1,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.2,
                    MediaQuery.of(context).size.height * 0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 18,
          child: ElevatedButton.icon(
            onPressed: () {
              navigateToWidget(context, TechnicalServiceScreen());
            },
            icon: Icon(
              Icons.repartition_rounded,
              size: 40.0,
            ),
            label: Text(
              'Teknik Servis',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.apply(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.mainbackgroundlinear1,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.2,
                    MediaQuery.of(context).size.height * 0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        Spacer(),
      ],
    );
  }
}

mixin NavigatorManager {
  void navigateToWidget(BuildContext context, Widget widget) {
    // ignore: inference_failure_on_instance_creation
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
