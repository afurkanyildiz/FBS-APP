import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/colors.dart';
import '../../product/service/cart.dart';
import 'package:provider/provider.dart';

import '../../product/widget/text/title_text.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              final product = cart.items[index].product;
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
                          child: Image.network(
                            product.imagePath.toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: maxWidth * .03),
                        Container(
                          width: maxWidth * .34,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName.toString(),
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
                                      if (cart.items[index].quantity > 1) {
                                        cart.decreaseQuantity(
                                            cart.items[index]);
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
                                    cart.items[index].quantity.toString(),
                                    style: TextStyle(
                                      fontSize: maxWidth < 500
                                          ? maxWidth * 0.035
                                          : maxWidth * 0.04,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (cart.items[index].quantity <
                                          cart.items[index].stock) {
                                        cart.increaseQuantity(
                                            cart.items[index]);
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
                              if (index >= 0 && index < cart.items.length) {
                                cart.removeFromCart(cart.items[index].product);
                              }
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
                    onPressed: () {},
                    child: Text(
                      "Satın Al",
                      style: TextStyle(fontSize: maxWidth * .028),
                    ),
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size.fromHeight(maxHeight * .03)),
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstants.mainbackgroundlinear1)),
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
