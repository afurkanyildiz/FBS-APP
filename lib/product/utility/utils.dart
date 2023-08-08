import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/user/adress_information.dart';
import 'package:firat_bilgisayar_sistemleri/feature/user/my_past_orders.dart';
import 'package:firat_bilgisayar_sistemleri/feature/user/pay_information.dart';
import 'package:firat_bilgisayar_sistemleri/feature/user/user_information.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../models/cart.dart';
import '../models/products_model.dart';

final Cart cart = Cart();

void addToCartButtonPressed(BuildContext context, Products products) {
  final cartItem = CartItem(product: products, quantity: 1);
  cart.addToCart(cartItem);

  // ignore: unused_local_variable
  List<Map<String, dynamic>> cartItems = [];

  // ignore: invalid_use_of_protected_member
  ScaffoldMessenger.of(context).setState(() {
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

Widget buildRatingStarts(double rating, double maxHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(5, (index) {
      final starValue = index + 1;
      return Icon(
        starValue <= rating ? Icons.star : Icons.star_border,
        size: maxHeight * 0.03,
        color: Colors.yellow,
      );
    }),
  );
}

Widget smallBuildRatingStarts(double rating, double maxHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(5, (index) {
      final starValue = index + 1;
      return Icon(
        starValue <= rating ? Icons.star : Icons.star_border,
        size: maxHeight * 0.024,
        color: Colors.yellow,
      );
    }),
  );
}

Future<List<Products>> getProductsByCategory(
  CollectionReference products,
  String categoryId,
) async {
  try {
    final querySnapshot =
        await products.where('categories', isEqualTo: categoryId).get();
    print('Query Snapshot: ${querySnapshot.docs}');
    print('Category ID: $categoryId');

    return querySnapshot.docs
        .map((doc) => Products(
              stock: doc['stock'] == null
                  ? 0
                  : int.tryParse(doc['stock'].toString())!,
            ).fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching products: $e');
    return [];
  }
}

class ShowMenu extends StatefulWidget {
  const ShowMenu({super.key});

  @override
  State<ShowMenu> createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final users = FirebaseAuth.instance.currentUser;
      print(users);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(users?.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          user = UserModel.fromJson(snapshot.data()!);
        });
      } else {
        print('Kullanıcı verileri bulunamadı.');
      }
    } catch (e) {
      print('Kullanıcı verilerini çekerken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var menuItems = <String>[
      'Kullanıcı Bilgileri',
      'Adres Bilgileri',
      'Ödeme Bilgileri',
      'Geçmiş Siparişlerim'
    ];

    final size = MediaQuery.of(context).size;
    final maxHeight = size.height;
    final maxWidth = size.width;
    return Scaffold(
      body: user != null
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: context.onlyTopPaddingMedium,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.06,
                              backgroundColor:
                                  ColorConstants.technicalServiceIcon,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height * 0.06,
                              ),
                            ),
                            Padding(
                              padding: context.onlyLeftPaddingLow,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        user!.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: maxHeight * 0.03),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.02,
                                      ),
                                      Text(
                                        user!.username.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: maxHeight * 0.03),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    user!.email,
                                    style:
                                        TextStyle(fontSize: maxHeight * 0.02),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: maxHeight * 0.1,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: menuItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ElevatedButton(
                            onPressed: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserInformationView()));
                                  break;
                                case 1:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdressInformation()));
                                  break;
                                case 2:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PayInformation()));
                                  break;
                                case 3:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyPastOrders()));
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Text(menuItems[index]),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
