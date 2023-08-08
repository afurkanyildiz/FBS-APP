import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/store_category_view.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/category_models.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../product/constants/colors.dart';
import '../../../product/utility/utils.dart';
import '../../../product/widget/text/title_text.dart';

class CategoryProductsView extends StatefulWidget {
  final String? categoryId;
  final Categories categories;
  const CategoryProductsView(
      {super.key, required this.categoryId, required this.categories});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    if (widget.categoryId == null) {
      return Center(
        child: Text('Invalid category'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TitleText(
            value: widget.categories.categoryName ?? 'Kategori Ürünleri'),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ShowMenu()));
            },
            child: Padding(
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
          ),
        ],
      ),
      body: Padding(
        padding: context.onlyTopPaddingMedium,
        child: FutureBuilder<List<Products>>(
          future: getProductsByCategory(products, widget.categoryId!),
          builder:
              (BuildContext context, AsyncSnapshot<List<Products>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final productsList = snapshot.data;
              if (productsList!.isEmpty) {
                return Center(
                  child: Text('No products available for this category.'),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxWidth * 0.6,
                  childAspectRatio: 0.68,
                ),
                itemCount: productsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductCard(product: productsList[index]);
                },
              );
            } else {
              return Center(
                child: Text('Error fetching products.'),
              );
            }
          },
        ),
      ),
    );
  }
}
