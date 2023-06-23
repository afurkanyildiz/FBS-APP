import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/product/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/small_title_text.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/subtitle_text.dart';
import '../../product/constants/padding.dart';

import '../../product/models/cart.dart';
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

    final Cart cart = Cart();

    void addToCartButtonPressed(Products products) {
      final cartItem = CartItem(product: products, quantity: 1);
      cart.addToCart(cartItem);

      List<Map<String, dynamic>> cartItems = [];

      setState(() {
        cartItems = cart.items.map((cartItem) {
          final product = cartItem.product;

          return {
            'productName': product.productName,
            'price': product.price,
            'quantity': cartItem.quantity,
          };
        }).toList();
      });
    }

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
                                addToCartButtonPressed: addToCartButtonPressed,
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
                                addToCartButtonPressed: addToCartButtonPressed,
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

class _SpecialForYouWiew extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  final Products? products;
  final Function addToCartButtonPressed;

  const _SpecialForYouWiew({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    required this.products,
    required this.addToCartButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPaddingLow,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              // ignore: inference_failure_on_instance_creation
              MaterialPageRoute(
                  builder: (context) => ProductDetailView(
                        product: products,
                      )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: maxWidth < 380 ? 12 / 10 : 12 / 8,
                  child: Padding(
                    padding: context.paddingLow,
                    child: products?.imagePaths != null &&
                            products!.imagePaths!.isNotEmpty
                        ? Image.network(
                            products!.imagePaths![0], // İlk resmi gösteriyoruz
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : Container(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: maxHeight * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products?.productName ?? '',
                          style: TextStyle(
                              fontSize: maxHeight * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: maxHeight * 0.02,
                        ),
                        Text(
                          products?.productExplanation ?? '',
                          overflow: TextOverflow.clip,
                          maxLines: maxWidth < 380 ? 2 : 3,
                          softWrap: maxWidth < 380 ? false : true,
                          style: TextStyle(
                              fontSize: maxHeight * 0.02,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: maxHeight * 0.01,
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                addToCartButtonPressed(products);
                              },
                              child: Text('Sepete Ekle',
                                  style: TextStyle(fontSize: maxHeight * 0.02),
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
                              '${(products?.price)?.toStringAsFixed(3)} ₺',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: maxHeight * 0.015),
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
  final double maxWidth;
  final double maxHeight;
  final Products? products;
  final Function addToCartButtonPressed;

  const _PopularProductsListView({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    required this.products,
    required this.addToCartButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPaddingLow,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              // ignore: inference_failure_on_instance_creation
              MaterialPageRoute(
                  builder: (context) => ProductDetailView(
                        product: products,
                      )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: maxWidth < 380 ? 12 / 10 : 12 / 8,
                  child: Padding(
                    padding: context.paddingLow,
                    child: products?.imagePaths != null &&
                            products!.imagePaths!.isNotEmpty
                        ? Image.network(
                            products!.imagePaths![0], // İlk resmi gösteriyoruz
                            fit: BoxFit.contain,
                          )
                        : Container(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: maxHeight * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products?.productName ?? '',
                          style: TextStyle(
                              fontSize: maxHeight * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: maxHeight * 0.02,
                        ),
                        Text(
                          products?.productExplanation ?? '',
                          overflow: TextOverflow.clip,
                          maxLines: maxWidth < 380 ? 1 : 2,
                          softWrap: maxWidth < 380 ? false : true,
                          style: TextStyle(
                              fontSize: maxHeight * 0.02,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: maxHeight * 0.01,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                addToCartButtonPressed(products);
                              },
                              child: Text('Sepete Ekle',
                                  style: TextStyle(fontSize: maxHeight * 0.02),
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
                                    MediaQuery.of(context).size.height * 0.01),
                            Expanded(
                              child: Text(
                                '${(products?.price)?.toStringAsFixed(3)} ₺',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: maxHeight * 0.015),
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
      ),
    );
  }
}
