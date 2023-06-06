import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:provider/provider.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/small_title_text.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/subtitle_text.dart';
import '../../product/constants/padding.dart';

import '../../product/service/cart.dart';

import '../../product/widget/card/store_view_small_card.dart';

class StoreView extends StatefulWidget {
  const StoreView({
    super.key,
  });

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    final response = products.withConverter(fromFirestore: (snapshot, options) {
      final data = snapshot.data()!;
      return Products(
              stock: data['stock'] == null
                  ? 0
                  : int.tryParse(data['stock'].toString())!)
          .fromFirebase(snapshot);
    }, toFirestore: (value, options) {
      if (value == false) throw FirebaseCustomException('$value not null');
      return value.toJson();
    }).get();
    // List<Product> expensiveProduct =
    //     products.where((product) => product.price < 25.000).toList();
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: TitleText(value: 'Ana Sayfa'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              iconSize: maxHeight * 0.03,
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
              )),
          Padding(
            padding: EdgeInsets.only(right: maxWidth * 0.02),
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.03,
              backgroundColor: ColorConstants.technicalServiceIcon,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: response,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Products?>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Placeholder();
            case ConnectionState.waiting:
            case ConnectionState.active:
              return LinearProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                final values =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                return Container(
                  height: maxHeight - kToolbarHeight,
                  width: maxWidth,
                  padding: context.horizontalPaddingLow,
                  child: ListView(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: maxHeight * 0.02,
                        ),
                        _CampaignView(),
                        SizedBox(
                          height: maxHeight * 0.01,
                        ),
                        _ChipView(),
                        _SpecialForYouTitleWiew(),
                        Container(
                          height: maxHeight * 0.36,
                          child: ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return _SpecialForYouWiew(
                                maxWidth: maxWidth,
                                maxHeight: maxHeight,
                                products: values[index],
                              );
                            },
                          ),
                        ),
                        _PopularProductsTitleView(),
                        Container(
                          height: maxHeight * 0.36,
                          child: ListView.builder(
                            itemCount: values.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return _PopularProductsListView(
                                maxWidth: maxWidth,
                                maxHeight: maxHeight,
                                products: values[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                );
              } else {
                return SizedBox();
              }
          }
        },
      ),
    );
  }

  void sepeteEkle(String? productId) async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null && productId != null) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          final productData = snapshot.data() as Map<String, dynamic>;
          final product = Products(
            stock: productData['stock'] == null
                ? 0
                : int.tryParse(productData['stock'].toString())!,
          ).fromJson(productData); // Düzeltme burada
          final cartItem = CartItem(product: product, quantity: 1);
          Provider.of<Cart>(context, listen: false).addToCart(cartItem);
          print(
              'sepeteEkle:${Provider.of<Cart>(context, listen: false).items.length}');
          print(user);
        }
        // ignore: inference_failure_on_untyped_parameter
      }).catchError((error) {
        print('Hata: $error');
      });
    }
  }
}

class _CampaignView extends StatelessWidget {
  const _CampaignView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.12,
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
                Center(child: TitleWhiteText(value: "%25 İndirim!")),
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
      height: MediaQuery.of(context).size.height * 0.17,
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
  final double maxWidth;
  final double maxHeight;
  final Products? products;

  const _SpecialForYouWiew({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    required this.products,
  }) : super(key: key);

  @override
  State<_SpecialForYouWiew> createState() => _SpecialForYouWiewState();
}

class _SpecialForYouWiewState extends State<_SpecialForYouWiew> {
  void onPressed() {
    final parentState = context.findAncestorStateOfType<_StoreViewState>();
    parentState?.sepeteEkle(widget.products?.id);
  }

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
              child: AspectRatio(
                aspectRatio: widget.maxWidth < 380 ? 12 / 10 : 12 / 8,
                child: Padding(
                  padding: context.paddingLow,
                  child: Image.network(
                    widget.products?.imagePath ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  width: widget.maxHeight * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.products?.productName ?? '',
                        style: TextStyle(
                            fontSize: widget.maxHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: widget.maxHeight * 0.02,
                      ),
                      Text(
                        widget.products?.productExplanation ?? '',
                        overflow: TextOverflow.clip,
                        maxLines: widget.maxWidth < 380 ? 2 : 3,
                        softWrap: widget.maxWidth < 380 ? false : true,
                        style: TextStyle(
                            fontSize: widget.maxHeight * 0.02,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: widget.maxHeight * 0.01,
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('Sepete Ekle',
                                style: TextStyle(
                                    fontSize: widget.maxHeight * 0.02),
                                textAlign: TextAlign.center),
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
                              width:
                                  MediaQuery.of(context).size.height * 0.015),
                          Text(
                            '${(widget.products?.price)?.toStringAsFixed(3)} ₺',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.maxHeight * 0.015),
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

class _PopularProductsListView extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;
  final Products? products;

  const _PopularProductsListView({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    required this.products,
  }) : super(key: key);

  @override
  State<_PopularProductsListView> createState() =>
      _PopularProductsListViewState();
}

class _PopularProductsListViewState extends State<_PopularProductsListView> {
  void onPressed() {
    final parentState = context.findAncestorStateOfType<_StoreViewState>();
    parentState?.sepeteEkle(widget.products?.id);
  }

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
              child: AspectRatio(
                aspectRatio: widget.maxWidth < 380 ? 12 / 10 : 12 / 8,
                child: Padding(
                  padding: context.paddingLow,
                  child: Image.network(
                    widget.products?.imagePath ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  width: widget.maxHeight * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.products?.productName ?? '',
                        style: TextStyle(
                            fontSize: widget.maxHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: widget.maxHeight * 0.02,
                      ),
                      Text(
                        widget.products?.productExplanation ?? '',
                        overflow: TextOverflow.clip,
                        maxLines: widget.maxWidth < 380 ? 1 : 2,
                        softWrap: widget.maxWidth < 380 ? false : true,
                        style: TextStyle(
                            fontSize: widget.maxHeight * 0.02,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: widget.maxHeight * 0.01,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('Sepete Ekle',
                                style: TextStyle(
                                    fontSize: widget.maxHeight * 0.02),
                                textAlign: TextAlign.center),
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
                            child: Text(
                              '${(widget.products?.price)?.toStringAsFixed(3)} ₺',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.maxHeight * 0.015),
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
