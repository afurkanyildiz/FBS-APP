import 'package:firat_bilgisayar_sistemleri/feature/store/shopping_cart_wiev.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/store_category_view.dart';
import 'package:firat_bilgisayar_sistemleri/feature/store/store_home_view.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../product/service/cart.dart';
import 'favorites_view.dart';

class StoreScreenView extends StatefulWidget {
  const StoreScreenView({super.key});

  @override
  State<StoreScreenView> createState() => _StoreScreenViewState();
}

class _StoreScreenViewState extends State<StoreScreenView> {
  final Cart cart = Cart();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cart,
      child: DefaultTabController(
        length: 4,
        child: StoreScaffoldView(),
      ),
    );
  }
}

class StoreScaffoldView extends StatefulWidget {
  StoreScaffoldView({
    super.key,
  });

  @override
  State<StoreScaffoldView> createState() => _StoreScaffoldViewState();
}

class _StoreScaffoldViewState extends State<StoreScaffoldView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: StoreFloatingActionButtonView(),
      bottomNavigationBar: StoreBottomAppBarView(),
      body: TabBarView(children: [
        StoreView(),
        CategoryView(),
        FavoritesWiew(),
        ShoppingCartScreen()
      ]),
    );
  }
}

class StoreBottomAppBarView extends StatelessWidget {
  const StoreBottomAppBarView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: ColorConstants.colorsBlack,
      notchMargin: 10,
      shape: CircularNotchedRectangle(),
      child: TabBar(indicatorSize: TabBarIndicatorSize.label, tabs: [
        Tab(
          height: MediaQuery.of(context).size.height * 0.05,
          icon: Icon(
            Icons.home,
            color: ColorConstants.technicalServiceIcon,
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
        Tab(
          height: MediaQuery.of(context).size.height * 0.05,
          icon: Icon(
            Icons.search,
            color: ColorConstants.technicalServiceIcon,
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
        Tab(
          height: MediaQuery.of(context).size.height * 0.05,
          icon: Icon(
            Icons.favorite,
            color: ColorConstants.technicalServiceIcon,
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
        Tab(
          height: MediaQuery.of(context).size.height * 0.05,
          icon: Icon(
            Icons.shopping_cart,
            color: ColorConstants.technicalServiceIcon,
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
      ]),
    );
  }
}

class StoreFloatingActionButtonView extends StatelessWidget {
  const StoreFloatingActionButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      backgroundColor: ColorConstants.technicalServiceIcon,
      child: Icon(Icons.view_stream),
      shape: CircleBorder(),
      heroTag: null,
      clipBehavior: Clip.none,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      elevation: 4.0,
      highlightElevation: 8.0,
      hoverElevation: 8.0,
      focusElevation: 8.0,
      disabledElevation: 0.0,
    );
  }
}
