import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';

import '../../../product/models/products_model.dart';
import '../../../product/service/cart.dart';
import '../../../product/widget/text/title_text.dart';

class ProductDetailView extends StatefulWidget {
  final Products? product;
  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
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
        title: TitleText(value: 'Ürün Detayı'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              iconSize: maxHeight * 0.03,
              onPressed: () {},
              icon: const Icon(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: context.onlyTopPaddingLow,
          child: Column(
            children: [
              Stack(children: [
                Padding(
                  padding: context.horizontalPaddingLow,
                  child: widget.product?.imagePaths?.length == 1
                      ? Center(
                          child: Image.network(
                            widget.product!.imagePaths!.first,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        )
                      : CarouselSlider(
                          items: widget.product?.imagePaths != null &&
                                  widget.product!.imagePaths!.isNotEmpty
                              ? widget.product!.imagePaths!
                                  .map((imagePath) => Image.network(
                                        imagePath,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ))
                                  .toList()
                              : [],
                          options: CarouselOptions(
                              viewportFraction: 0.8,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 18 / 13,
                              onPageChanged: (int index,
                                  CarouselPageChangedReason reason) {
                                setState(() {
                                  _currentPage = index;
                                });
                              }),
                        ),
                ),
                productFavShareButton(maxWidth: maxWidth, maxHeight: maxHeight)
              ]),
              imageDotsIndicator(widget: widget, currentPage: _currentPage),
              productName(
                  maxWidth: maxWidth, maxHeight: maxHeight, widget: widget),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: context.onlyBottomPaddingMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Consumer<Cart>(
              builder: (context, cart, _) {
                return ListTile(
                  leading: Padding(
                    padding: context.onlyLeftPaddingLow,
                    child: ElevatedButton(
                      onPressed: () {
                        addToCartButtonPressed(widget.product!);
                      },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        fixedSize: MaterialStateProperty.all(
                            Size.fromHeight(maxHeight * .03)),
                        backgroundColor:
                            MaterialStateProperty.all(ColorConstants.chipColor),
                      ),
                      child: Text(
                        'Sepete Ekle',
                        style: TextStyle(
                          fontSize: maxHeight * .028,
                          color: ColorConstants.colorsBlack,
                        ),
                      ),
                    ),
                  ),
                  trailing: Padding(
                    padding: context.onlyRightPaddingMedium,
                    child: Text(
                      '${widget.product?.price.toString()} ₺',
                      style: TextStyle(
                          fontSize: maxHeight * .03,
                          color: ColorConstants.colorsBlack),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class productFavShareButton extends StatelessWidget {
  const productFavShareButton({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
  });

  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: maxWidth * 0.05,
        right: maxWidth * 0.02,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                      Size(maxWidth * 0.08, maxHeight * 0.05)),
                  backgroundColor:
                      const MaterialStatePropertyAll(ColorConstants.chipColor),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
              child: Icon(
                Icons.share,
                size: maxHeight * 0.03,
              ),
            ),
            SizedBox(
              height: maxHeight * 0.008,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                    Size(maxWidth * 0.08, maxHeight * 0.05)),
                backgroundColor:
                    const MaterialStatePropertyAll(ColorConstants.chipColor),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                size: maxHeight * 0.03,
              ),
            )
          ],
        ));
  }
}

class imageDotsIndicator extends StatelessWidget {
  const imageDotsIndicator({
    super.key,
    required this.widget,
    required int currentPage,
  }) : _currentPage = currentPage;

  final ProductDetailView widget;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: widget.product?.imagePaths?.length ?? 0,
      position: _currentPage.toInt(),
      decorator: DotsDecorator(
          activeColor: ColorConstants.mainbackgroundlinear1,
          size: Size(10.0, 10.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}

class productName extends StatelessWidget {
  const productName({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
    required this.widget,
  });

  final double maxWidth;
  final double maxHeight;
  final ProductDetailView widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPaddingLow,
      child: Container(
        width: maxWidth,
        height: maxHeight * .07,
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.colorsBlack, width: 1.0),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: context.onlyLeftPaddingLow,
          child: Center(
            child: RichText(
              text: TextSpan(
                  text: widget.product?.productName ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: maxHeight * 0.015),
                  children: <TextSpan>[
                    TextSpan(text: '  '),
                    TextSpan(
                      text: widget.product?.productExplanation ?? '',
                      style: TextStyle(
                          color: Colors.black54, fontSize: maxHeight * 0.015),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
