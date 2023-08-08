import 'package:firat_bilgisayar_sistemleri/feature/store/product/product_detail.dart';
import 'package:firat_bilgisayar_sistemleri/product/models/favorites.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';

import '../../product/constants/colors.dart';
import '../../product/utility/utils.dart';
import '../../product/widget/text/title_text.dart';

class FavoritesWiew extends StatefulWidget {
  const FavoritesWiew({super.key});

  @override
  State<FavoritesWiew> createState() => _FavoritesWiewState();
}

class _FavoritesWiewState extends State<FavoritesWiew> {
  @override
  void initState() {
    super.initState();
    final favorites = Provider.of<Favorites>(context, listen: false);
    favorites.loadFavoritesFromFirestore().then((_) {
      setState(() {});
    });
  }

  List<Map<String, dynamic>> pageItems = [];

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final favorites = Provider.of<Favorites>(context);

    Future<void> _refreshPage() async {
      favorites.stopListeningToFirestore();
      await favorites.loadFavoritesFromFirestore();
      favorites.startListeningToFirestore();
      setState(() {});
      print('Refreshing');
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
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Consumer<Favorites>(builder: (context, favorites, _) {
          return ListView.builder(
              itemCount: favorites.items.length,
              itemBuilder: (BuildContext context, int index) {
                final pageItem = favorites.items[index];
                final product = pageItem.product;

                final isFavorite = favorites.isFavorite(product);

                final totalRating = product.total_rating ?? 0;
                final totalVotes = product.total_votes ?? 0;
                final averageRating = totalRating / totalVotes;

                return Padding(
                  padding: context.onlyTopPaddingLow,
                  child: Card(
                    color: Colors.white,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            // ignore: inference_failure_on_instance_creation
                            MaterialPageRoute(
                                builder: (context) => ProductDetailView(
                                      product: product,
                                      favorites: favorites,
                                    )));
                      },
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
                                      product.imagePaths![
                                          0], // İlk resmi gösteriyoruz
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    )
                                  : Container(),
                            ),
                            SizedBox(width: maxWidth * .03),
                            Container(
                              width: maxWidth * .44,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productExplanation ?? '',
                                    overflow: TextOverflow.clip,
                                    maxLines: maxWidth < 380 ? 1 : 2,
                                    softWrap: maxWidth < 380 ? false : true,
                                    style: TextStyle(
                                      fontSize: maxWidth * 0.04,
                                    ),
                                  ),
                                  Text(
                                    '${(product.price ?? 0).toString()} ₺',
                                    style: TextStyle(
                                        fontSize: maxHeight * 0.022,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      buildRatingStarts(
                                          averageRating, maxHeight),
                                      Text(
                                          '(${averageRating.toStringAsFixed(1)})',
                                          style: TextStyle(
                                              fontSize: maxHeight * 0.016))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: maxWidth * .001),
                            OutlinedButton(
                              onPressed: () {
                                favorites.toogleFavorite(product);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? ColorConstants.chipColor
                                    : null,
                                size: maxHeight * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}
