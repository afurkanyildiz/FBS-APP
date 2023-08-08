import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/product/category_product.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/product/product_detail.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/category_models.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/utils.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';

import '../../product/models/favorites.dart';
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

    final productResponse =
        products.withConverter(fromFirestore: ((snapshot, options) {
      return Products(
              stock: snapshot['stock'] == null
                  ? 0
                  : int.tryParse(snapshot['stock'].toString())!)
          .fromFirebase(snapshot);
    }), toFirestore: ((value, options) {
      if (value == false) throw FirebaseCustomException('$value not null');
      return value.toJson();
    }));

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;

    // final hasSearchQuery = searchQuery.isNotEmpty;

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
                    AsyncSnapshot<QuerySnapshot<Categories>> snapshot) {
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
                            return Padding(
                              padding: EdgeInsets.all(maxWidth * .03),
                              child: CategoryCard(category: values[index]),
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
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            maxWidth * 0.6, // Yatayda maksimum genişlik
                        // mainAxisSpacing: 2, // Dikey aralık
                        // crossAxisSpacing: 8, // Yatay aralık
                        childAspectRatio: 0.68,
                      ), // Genişlik/yükseklik oranı
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductCard(
                          product: filteredProducts[index],
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
  final Categories category;

  CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final categoryId = category.id ?? '';
        Navigator.push(
            context,
            // ignore: inference_failure_on_instance_creation
            MaterialPageRoute(
                builder: (context) => CategoryProductsView(
                      categoryId: categoryId,
                      categories: category,
                    )));
      },
      child: Card(
        color: ColorConstants.textfieldWhite,
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
      aspectRatio: 2.0,
      child: Image.network(category?.imagePath ?? ''),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final maxWidth = size.width;
    final maxHeight = size.height;

    final favorites = Provider.of<Favorites>(context);
    return Card(
      color: ColorConstants.textfieldWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            // ignore: inference_failure_on_instance_creation
            MaterialPageRoute(
              builder: (context) => ProductDetailView(
                product: product,
                favorites: favorites,
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProductImage(product: product),
            SizedBox(
              height: maxHeight * .01,
            ),
            ProductText(
              product: product,
            ),
            addToCartWidget(product: product, maxHeight: maxHeight),
          ],
        ),
      ),
    );
  }
}

class addToCartWidget extends StatelessWidget {
  const addToCartWidget({
    super.key,
    required this.product,
    required this.maxHeight,
  });

  final Products product;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.onlyLeftPaddingLow,
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton(
          onPressed: () {
            addToCartButtonPressed(context, product);
          },
          child: Text('Sepete Ekle',
              style: TextStyle(fontSize: maxHeight * 0.02),
              textAlign: TextAlign.center),
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(ColorConstants.textfieldWhite),
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.mainbackgroundlinear1),
            overlayColor: MaterialStateProperty.all(ColorConstants.chipColor),
          ),
        ),
      ),
    );
  }
}

class ProductText extends StatelessWidget {
  final Products product;

  const ProductText({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;
    final totalRating = product.total_rating ?? 0;
    final totalVotes = product.total_votes ?? 0;
    final averageRating = totalRating / totalVotes;
    return Padding(
      padding: context.onlyLeftPaddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            product.productExplanation.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: maxWidth < 380 ? 1 : 2,
            softWrap: maxWidth < 380 ? false : true,
            style: TextStyle(
                fontSize: maxHeight * 0.02, fontWeight: FontWeight.normal),
          ),
          Row(
            children: [
              buildRatingStarts(averageRating, maxHeight),
              Text('(${averageRating.toStringAsFixed(1)})',
                  style: TextStyle(fontSize: maxHeight * 0.016))
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${(product.price)?.toStringAsFixed(3)} ₺',
              style: TextStyle(
                  fontSize: maxHeight * 0.02, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final Products product;

  const ProductImage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;

    final imagePath = product.imagePaths?.first ?? '';
    return AspectRatio(
      aspectRatio: maxWidth < 380 ? 12 / 10 : 12 / 8,
      // ignore: unnecessary_null_comparison
      child: product.imagePaths != null && product.imagePaths!.isNotEmpty
          ? Image.network(
              imagePath, // İlk resmi gösteriyoruz
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

class categorySearchArea extends StatelessWidget {
  final double maxHeight;
  final TextEditingController searchController;
  // ignore: inference_failure_on_function_return_type
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
