import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/category_models.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    CollectionReference category =
        FirebaseFirestore.instance.collection('category');

    final response = category.withConverter(fromFirestore: (snapshot, options) {
      return Categories().fromFirebase(snapshot);
    }, toFirestore: (value, options) {
      if (value == false) throw FirebaseCustomException('$value not null');
      return value.toJson();
    }).get();

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: TitleText(value: 'Kategoriler'),
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
      body: categoryScrollView(
          maxHeight: maxHeight, response: response, maxWidth: maxWidth),
    );
  }
}

class categoryScrollView extends StatelessWidget {
  const categoryScrollView({
    super.key,
    required this.maxHeight,
    required this.response,
    required this.maxWidth,
  });

  final double maxHeight;
  final Future<QuerySnapshot<Categories>> response;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
            child: Padding(
              padding: context.horizontalPaddingMedium,
              child: categorySearchArea(maxHeight: maxHeight),
            ),
          ),
          FutureBuilder(
              future: response,
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
                                  crossAxisCount: 2),
                          itemCount: values.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(
                                  maxWidth * .03,
                                ),
                                child: categoryCard(categories: values[index]),
                              ),
                            );
                          });
                    } else {
                      return SizedBox();
                    }
                }
              }),
        ],
      ),
    );
  }
}

class categoryCard extends StatelessWidget {
  final Categories? categories;
  const categoryCard({
    super.key,
    required this.categories,
  });

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
            child: categoryImage(categories: categories),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          categoryText(categories: categories)
        ],
      ),
    );
  }
}

class categoryText extends StatelessWidget {
  const categoryText({
    super.key,
    required this.categories,
  });

  final Categories? categories;

  @override
  Widget build(BuildContext context) {
    return Text(
      categories?.categoryName ?? '',
      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
    );
  }
}

class categoryImage extends StatelessWidget {
  const categoryImage({
    super.key,
    required this.categories,
  });

  final Categories? categories;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.network(categories?.imagePath ?? ''),
    );
  }
}

class categorySearchArea extends StatelessWidget {
  const categorySearchArea({
    super.key,
    required this.maxHeight,
  });

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
