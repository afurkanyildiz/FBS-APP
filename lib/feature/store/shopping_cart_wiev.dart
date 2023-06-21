import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';

import '../../product/constants/colors.dart';
import '../../product/models/products_model.dart';
import '../../product/service/cart.dart';
import '../../product/widget/text/title_text.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   final cart = Provider.of<Cart>(context);
  //   cart.addListener(() {
  //     setState(() {
  //       // Update the UI to reflect the changes to the cart.
  //       cartItems = cart.items.map((cartItem) {
  //         final product = cartItem.product;

  //         return {
  //           'productName': product.productName,
  //           'price': product.price,
  //           'quantity': cartItem.quantity,
  //         };
  //       }).toList();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    void addToCartButtonPressed(Products products) {
      cart.removeFromCart(products);
    }

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(value: 'Sepetim'),
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
            ),
          ),
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
      body: Consumer<Cart>(
        builder: (context, cart, _) {
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (BuildContext context, int index) {
              final cartItem = cart.items[index];
              final product = cartItem.product;

              return Padding(
                padding: context.onlyTopPaddingLow,
                child: Card(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: context.onlyLeftPaddingLow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: maxHeight * 0.1,
                          width: maxWidth < 400
                              ? maxWidth * 0.20
                              : maxWidth * 0.25,
                          child: product.imagePaths != null &&
                                  product.imagePaths!.isNotEmpty
                              ? Image.network(
                                  product
                                      .imagePaths![0], // İlk resmi gösteriyoruz
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )
                              : Container(),
                        ),
                        SizedBox(width: maxWidth * .03),
                        Container(
                          width: maxWidth * .34,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName ?? '',
                                style: TextStyle(
                                  fontSize: maxWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (product.price ?? 0).toString(),
                                style: TextStyle(fontSize: maxHeight * 0.022),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        cart.decreaseQuantity(cartItem);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: maxWidth < 500
                                          ? maxWidth * 0.035
                                          : maxWidth * 0.04,
                                    ),
                                  ),
                                  Text(
                                    cartItem.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: maxWidth < 500
                                          ? maxWidth * 0.035
                                          : maxWidth * 0.04,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (cartItem.quantity < cartItem.stock) {
                                        cart.increaseQuantity(cartItem);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: maxWidth < 500
                                          ? maxWidth * 0.035
                                          : maxWidth * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: maxHeight * .07,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          height: maxHeight * 0.05,
                          width: maxWidth * 0.15,
                          child: IconButton(
                            onPressed: () {
                              addToCartButtonPressed(product);
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              size: maxHeight * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
                  title: Text(
                    'Toplam Fiyat: ${cart.totalPrice.toStringAsFixed(3)} ₺',
                    style: TextStyle(fontSize: maxHeight * .025),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Satın alma işlemleri gerçekleştirilebilir
                    },
                    child: Text(
                      "Satın Al",
                      style: TextStyle(fontSize: maxWidth * .028),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size.fromHeight(maxHeight * .03)),
                      backgroundColor: MaterialStateProperty.all(
                          ColorConstants.mainbackgroundlinear1),
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
