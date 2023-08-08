import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

import '../../../product/models/products_model.dart';
import '../../../product/models/cart.dart';
import '../../../product/utility/utils.dart';
import '../../../product/widget/text/title_text.dart';

class ProductDetailView extends StatefulWidget {
  final Products product;
  final Favorites favorites;
  const ProductDetailView(
      {Key? key, required this.product, required this.favorites})
      : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: context.onlyTopPaddingLow,
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: context.horizontalPaddingLow,
                    child: widget.product.imagePaths?.length == 1
                        ? Center(
                            child: Image.network(
                              widget.product.imagePaths!.first,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          )
                        : CarouselSlider(
                            items: widget.product.imagePaths != null &&
                                    widget.product.imagePaths!.isNotEmpty
                                ? widget.product.imagePaths!
                                    .map((imagePath) => Image.network(
                                          imagePath,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
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
                  ProductFavShareButton(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      widget: widget,
                      favorites: widget.favorites
                      // addToFavoritesButtonPressed: addToFavoritesButtonPressed,
                      ),
                ],
              ),
              imageDotsIndicator(widget: widget, currentPage: _currentPage),
              productName(
                  maxWidth: maxWidth, maxHeight: maxHeight, widget: widget),
              SizedBox(
                height: maxHeight * .01,
              ),
              productDetail(widget: widget, maxHeight: maxHeight),
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
            Consumer(
              builder: (context, watch, _) {
                return ListTile(
                  leading: Padding(
                    padding: context.onlyLeftPaddingLow,
                    child: ElevatedButton(
                      onPressed: () {
                        addToCartButtonPressed(context, widget.product);
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
                      '${widget.product.price.toString()} ₺',
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

class productDetail extends StatelessWidget {
  const productDetail({
    super.key,
    required this.maxHeight,
    required this.widget,
  });

  final ProductDetailView widget;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPaddingLow,
      child: widget.product.technicalDetails != null &&
              widget.product.technicalDetails!.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorConstants.colorsBlack,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DataTable(
                headingRowHeight: 0,
                columns: [
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: widget.product.technicalDetails!.entries
                    .map(
                      (entry) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              entry.key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.colorsBlack,
                                  fontSize: maxHeight * 0.015),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${entry.value}',
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: ColorConstants.colorsBlack,
                                  fontSize: maxHeight * 0.015),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          : SizedBox(), // Eğer technicalDetails boş ise hiçbir şey çizme
    );
  }
}

class ProductFavShareButton extends StatefulWidget {
  const ProductFavShareButton({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    required this.widget,
    required this.favorites,
  }) : super(key: key);

  final double maxWidth;
  final double maxHeight;
  final ProductDetailView widget;
  final Favorites favorites;

  @override
  State<ProductFavShareButton> createState() => _ProductFavShareButtonState();
}

class _ProductFavShareButtonState extends State<ProductFavShareButton> {
  @override
  Widget build(BuildContext context) {
    final favorites = Favorites();
    final isFavorite = widget.favorites.isFavorite(widget.widget.product);
    return Positioned(
      top: widget.maxWidth * 0.019,
      right: widget.maxWidth * 0.02,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(widget.maxWidth * 0.08, widget.maxHeight * 0.05),
              ),
              backgroundColor: MaterialStateProperty.all(
                ColorConstants.chipColor,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Icon(
              Icons.share,
              size: widget.maxHeight * 0.03,
            ),
          ),
          SizedBox(
            height: widget.maxHeight * 0.008,
          ),
          ElevatedButton(
            onPressed: () {
              favorites.toogleFavorite(widget.widget.product);
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(widget.maxWidth * 0.08, widget.maxHeight * 0.05),
              ),
              backgroundColor: MaterialStateProperty.all(
                ColorConstants.chipColor,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? ColorConstants.textfieldWhite : null,
              size: widget.maxHeight * 0.03,
            ),
          ),
        ],
      ),
    );
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
      dotsCount: widget.product.imagePaths?.length ?? 0,
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
    final totalRating = widget.product.total_rating ?? 0;
    final totalVotes = widget.product.total_votes ?? 0;
    final averageRating = totalRating / totalVotes;
    return Padding(
      padding: context.horizontalPaddingLow,
      child: Container(
        width: maxWidth,
        height: maxHeight * .1,
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.colorsBlack, width: 1.0),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: context.onlyLeftPaddingLow,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: context.onlyTopPaddingLow,
                  child: RichText(
                    text: TextSpan(
                      text: widget.product.productName ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: maxHeight * 0.015),
                      children: <TextSpan>[
                        TextSpan(text: '  '),
                        TextSpan(
                          text: widget.product.productExplanation ?? '',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: maxHeight * 0.015),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('(${averageRating.toStringAsFixed(1)})',
                        style: TextStyle(fontSize: maxHeight * 0.016)),
                    smallBuildRatingStarts(averageRating, maxHeight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
