import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/product/product_detail.dart';

import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';

import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/colors.dart';
import '../../product/models/cart.dart';

class FavoritesWiew extends StatefulWidget {
  const FavoritesWiew({Key? key}) : super(key: key);

  @override
  State<FavoritesWiew> createState() => _FavoritesWiewState();
}

class _FavoritesWiewState extends State<FavoritesWiew> {
  Cart? cart;
  @override
  Widget build(BuildContext context) {
    // cart = Provider.of<Cart>(context, listen: false);
    final Cart cart = Cart();

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    final response = products.withConverter(fromFirestore: (snapshot, options) {
      final data = snapshot.data()!;
      return Products(
        stock:
            data['stock'] == null ? 0 : int.tryParse(data['stock'].toString())!,
      ).fromFirebase(snapshot);
    }, toFirestore: (value, options) {
      if (value == false) throw FirebaseCustomException('$value not null');
      return value.toJson();
    }).get();

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
        title: TitleText(value: 'Favorilerim'),
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

                return ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: context.onlyTopPaddingLow,
                        child: InkWell(
                          // ignore: inference_failure_on_instance_creation
                          onTap: () {
                            Navigator.push(
                                context,
                                // ignore: inference_failure_on_instance_creation
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailView(
                                          product: values[index],
                                        )));
                          },
                          child: Card(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                            child: Padding(
                              padding: context.onlyLeftPaddingLow,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  favoritesProductImage(
                                      maxHeight: maxHeight,
                                      maxWidth: maxWidth,
                                      products: values[index]),
                                  SizedBox(
                                    width: maxWidth * .03,
                                  ),
                                  productGeneralInformation(
                                      maxWidth: maxWidth,
                                      products: values[index],
                                      maxHeight: maxHeight),
                                  SizedBox(
                                    width: maxWidth < 400
                                        ? maxWidth * 0.01
                                        : maxWidth < 450
                                            ? maxWidth * 0.03
                                            : maxWidth * 0.08,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${(values[index]?.price).toString()} ₺',
                                          style: TextStyle(
                                              fontSize: maxWidth * .035),
                                        ),
                                        Icon(
                                          Icons.favorite_outline,
                                          size: maxHeight * .03,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              addToCartButtonPressed(
                                                  values[index]!);
                                            },
                                            style: ButtonStyle(
                                                fixedSize:
                                                    MaterialStateProperty.all(
                                                        Size.fromHeight(
                                                            maxHeight * .04)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ColorConstants
                                                            .mainbackgroundlinear1)),
                                            child: Text(
                                              'Sepete Ekle',
                                              style: TextStyle(
                                                  fontSize: maxWidth * .028),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return SizedBox();
              }
          }
        },
      ),
    );
  }
}

class productGeneralInformation extends StatelessWidget {
  final double maxWidth;
  final Products? products;
  final double maxHeight;

  const productGeneralInformation({
    super.key,
    required this.maxWidth,
    required this.products,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth * .4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            products?.productName ?? '',
            style: TextStyle(
                fontSize: maxHeight * 0.025, fontWeight: FontWeight.bold),
          ),
          Text(
            products?.productExplanation ?? '',
            overflow: TextOverflow.clip,
            maxLines: maxWidth < 0 ? 1 : 2,
            softWrap: maxWidth < 380 ? false : true,
            style: TextStyle(
                fontSize: maxHeight * 0.018, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: maxHeight * .001,
          ),
          Row(children: [
            RatingBarIndicator(
              rating: products?.rating?.toDouble() ?? 0.0,
              itemCount: 5,
              itemSize: maxWidth * .05,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            )
          ]),
        ],
      ),
    );
  }
}

class favoritesProductImage extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;
  final Products? products;
  const favoritesProductImage({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxHeight * .1,
      width: maxWidth * .25,
      child: products?.imagePaths != null && products!.imagePaths!.isNotEmpty
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
    );
  }
}
