// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';

import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/small_title_text.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/subtitle_text.dart';

import '../../product/constants/padding.dart';
import '../../product/widget/card/store_view_small_card.dart';
import '../../product/widget/text/title_text.dart';

class Product {
  final String name;
  final String explanation;
  final String imagePath;
  final double price;
  int count = 0;

  Product(
      {required this.name,
      required this.explanation,
      required this.price,
      required this.imagePath});
}

class StoreView extends StatefulWidget {
  const StoreView({
    super.key,
  });

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  List<Product> products = [
    Product(
        name: 'Monster',
        explanation:
            'Monster Abra A5 V16.7.3 Intel Core I5-11400h 16gb Ram 500gb Ssd 4gb Gtx1650 Freedos 15.6" Fhd 144hz ABRA A5 V16.7.3',
        imagePath: 'assets/images/computer.png',
        price: 26.299),
    Product(
        name: 'Apple',
        explanation: 'Apple Macbook Air 13'
            ' M1 8gb 256gb Ssd Uzay Grisi Dizüstü Bilgisayar MGN63TU/A',
        imagePath: 'assets/images/macbook.png',
        price: 18.049),
    Product(
        name: 'Monster',
        explanation:
            'Monster Abra A5 V17.4.6 Intel Core I7 11800h 16gb Ram 1 Tb Ssd Rtx 3060 Freedos 15,6 Inç Fhd 144 Hz ABRA A5 V17.4.6',
        imagePath: 'assets/images/computer.png',
        price: 25.999),
    Product(
        name: 'Monster',
        explanation:
            'Monster Abra A7 V12.5.3 Intel Core I5-11400h 16gb Ram 500gb Ssd 4gb Gtx1650 Freedos 17.3" Fhd 144hz ABRA A7 V12.5.3',
        imagePath: 'assets/images/computer.png',
        price: 17.199),
    Product(
        name: 'Apple',
        explanation:
            'Apple Macbook Air M2 Çip 16 Gb 512 Gb Ssd 13.6" Yıldız Işığı Notebook Z15z000k6 125034737',
        imagePath: 'assets/images/macbook.png',
        price: 33.999),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    return Scaffold(
      body: ListView(
        children: [
          _Header(),
          _CampaignView(),
          _ChipView(),
          _SpecialForYouTitleWiew(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.36,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _SpecialForYouWiew(
                  maxWidth: maxWidth,
                  product: products[index],
                );
              },
            ),
          ),
          _PopularProductsTitleView(),
          _PopularProductsListView()
        ],
      ),
    );
  }
}

class _CampaignView extends StatelessWidget {
  const _CampaignView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(.14),
      child: Padding(
        padding: listPaddingHorizontal,
        child: Card(
          color: ColorConstants.mainbackgroundlinear1,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Padding(
            padding: paddingLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitleWhiteText(value: "Haftanın Kampanyası"),
                TitleWhiteText(value: "%25 İndirim!"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipView extends StatelessWidget {
  const _ChipView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SmallCardView(
            icon: FontAwesomeIcons.boltLightning,
            title: 'Son\n Fırsatlar!',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.book,
            title: 'Servis\n Randevu',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.gamepad,
            title: 'Gamer\n Özel',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.gift,
            title: 'Hızlı\n Teslimat',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.arrowPointer,
            title: 'Diğer\n Hizmetler',
          ),
        ],
      ),
    );
  }
}

class _SpecialForYouTitleWiew extends StatelessWidget {
  const _SpecialForYouTitleWiew({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: listPaddingHorizontal,
      child: Row(
        children: [
          Expanded(
            child: SmallTitleText(
              value: StringConstants.specialForYou,
            ),
          ),
          // Spacer(),
          TextButton(
            onPressed: () {},
            child: SubTitleText(
              value: StringConstants.seeAll,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialForYouWiew extends StatefulWidget {
  final Product product;
  final double maxWidth;

  const _SpecialForYouWiew(
      {Key? key, required this.maxWidth, required this.product})
      : super(key: key);

  @override
  State<_SpecialForYouWiew> createState() => _SpecialForYouWiewState();
}

class _SpecialForYouWiewState extends State<_SpecialForYouWiew> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPaddingLow,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.grey, width: 1),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 12 / 8,
                child: Padding(
                  padding: context.paddingLow,
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name.toString(),
                        style: TextStyle(
                            fontSize: widget.maxWidth < 380 ? 16.0 : 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        widget.product.explanation.toString(),
                        overflow: TextOverflow.clip,
                        maxLines: widget.maxWidth < 380 ? 2 : 3,
                        softWrap: widget.maxWidth < 350 ? false : true,
                        style: TextStyle(
                            fontSize: widget.maxWidth < 380 ? 14.0 : 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: Text('Sepete Ekle'),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  ColorConstants.textfieldWhite),
                              backgroundColor: MaterialStateProperty.all(
                                  ColorConstants.mainbackgroundlinear1),
                              overlayColor: MaterialStateProperty.all(
                                  ColorConstants.chipColor),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.height * 0.01),
                          Expanded(
                            // child: Text(
                            //   '\$${(widget.product.price * widget.product.count).toStringAsFixed(2)} ₺',
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            child: Text(
                              '${(widget.product.price).toStringAsFixed(3)} ₺',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PopularProductsTitleView extends StatelessWidget {
  const _PopularProductsTitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: listPaddingHorizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SmallTitleText(
              value: StringConstants.popularProducts,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: SubTitleText(
              value: StringConstants.seeAll,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularProductsListView extends StatelessWidget {
  const _PopularProductsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: listPaddingHorizontal,
            child: Row(
              children: [
                Expanded(
                  child: Placeholder(),
                ),
                Expanded(
                  child: Placeholder(),
                )
              ],
            ),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.onlyBottomPaddingMedium,
      child: Row(
        children: [
          Spacer(),
          _Title(),
          Spacer(
            flex: 8,
          ),
          _ShopCartIcon(),
          _NotificationsIcon(),
          Spacer()
        ],
      ),
    );
  }
}

class _NotificationsIcon extends StatelessWidget {
  const _NotificationsIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {}, icon: Icon(Icons.notifications_none_outlined));
  }
}

class _ShopCartIcon extends StatelessWidget {
  const _ShopCartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.shopping_cart_outlined,
        ));
  }
}

class _Title extends StatelessWidget {
  const _Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TitleText(
      value: StringConstants.homePage,
    );
  }
}
