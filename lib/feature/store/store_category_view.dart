import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/category_models.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../product/models/products_model.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool showCategories = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleSearchQueryChanged(String query) {
    setState(() {
      searchQuery = query;
      showCategories = query.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('category');
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    final categoryResponse = categories.withConverter(
      fromFirestore: (snapshot, options) {
        return Categories().fromFirebase(snapshot);
      },
      toFirestore: (value, options) {
        if (value == false) throw FirebaseCustomException('$value not null');
        return value.toJson();
      },
    ).get();

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;

    final hasSearchQuery = searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(value: 'Arama'),
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Padding(
                padding: context.horizontalPaddingMedium,
                child: categorySearchArea(
                  maxHeight: maxHeight,
                  searchController: searchController,
                  onSearchQueryChanged: _handleSearchQueryChanged,
                ),
              ),
            ),
            if (showCategories) ...[
              FutureBuilder(
                future: categoryResponse,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Categories?>> snapshot) {
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
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: values.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(maxWidth * .03),
                                child: CategoryCard(category: values[index]),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                  }
                },
              ),
            ] else ...[
              FutureBuilder(
                future: _getProducts(products),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Products>> productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (productSnapshot.hasData) {
                    final products = productSnapshot.data!;
                    final filteredProducts = products
                        .where((product) => product.productName!
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(maxWidth * .03),
                            child: ProductCard(
                              product: filteredProducts[index],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<List<Products>> _getProducts(CollectionReference products) async {
    final querySnapshot = await products.get();
    return querySnapshot.docs
        .map((doc) => Products(
                stock: doc['stock'] == null
                    ? 0
                    : int.tryParse(doc['stock'].toString())!)
            .fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

class CategoryCard extends StatelessWidget {
  final Categories? category;

  CategoryCard({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey, width: 1),
      ),
      elevation: 2.0,
      child: Column(
        children: [
          Expanded(
            child: CategoryImage(category: category),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .001,
          ),
          CategoryText(category: category),
        ],
      ),
    );
  }
}

class CategoryText extends StatelessWidget {
  final Categories? category;

  const CategoryText({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.onlyBottomPaddingNormal,
      child: Text(
        category?.categoryName ?? '',
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),
      ),
    );
  }
}

class CategoryImage extends StatelessWidget {
  final Categories? category;

  const CategoryImage({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.network(category?.imagePath ?? ''),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products? product;

  const ProductCard({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey, width: 1),
      ),
      elevation: 8.0,
      child: Column(
        children: [
          Expanded(
            child: ProductImage(product: product),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          ProductText(product: product),
        ],
      ),
    );
  }
}

class ProductText extends StatelessWidget {
  final Products? product;

  const ProductText({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;
    return Column(
      children: [
        // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Center(
          child: Text(
            product?.productExplanation ?? '',
            overflow: TextOverflow.clip,
            maxLines: maxWidth < 380 ? 1 : 2,
            softWrap: maxWidth < 380 ? false : true,
            style: TextStyle(
                fontSize: maxHeight * 0.015, fontWeight: FontWeight.normal),
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          '${product?.price ?? 0}',
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),
        ),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  final Products? product;

  const ProductImage({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePath = product?.imagePaths?.first ?? '';
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.network(imagePath),
    );
  }
}

class categorySearchArea extends StatelessWidget {
  final double maxHeight;
  final TextEditingController searchController;
  final Function(String) onSearchQueryChanged;

  const categorySearchArea({
    Key? key,
    required this.maxHeight,
    required this.searchController,
    required this.onSearchQueryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: onSearchQueryChanged,
      decoration: InputDecoration(
        hintText: 'Ürün Arayın...',
        hintStyle: TextStyle(color: Colors.grey, fontSize: maxHeight * .028),
        prefixIcon: Icon(
          Icons.search,
          color: ColorConstants.technicalServiceIcon,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
