import 'package:firat_bilgisayar_sistemleri/feature/store/store_home_view.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:flutter/material.dart';

class StoreScreenView extends StatefulWidget {
  const StoreScreenView({super.key});

  @override
  State<StoreScreenView> createState() => _StoreScreenViewState();
}

class _StoreScreenViewState extends State<StoreScreenView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: StoreScaffoldView(),
    );
  }
}

class StoreScaffoldView extends StatelessWidget {
  const StoreScaffoldView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: StoreFloatingActionButtonView(),
      bottomNavigationBar: StoreBottomAppBarView(),
      body: TabBarView(
          children: [StoreView(), StoreView(), StoreView(), StoreView()]),
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
      child: TabBar(tabs: [
        Tab(
          icon: Icon(Icons.home, color: ColorConstants.technicalServiceIcon),
        ),
        Tab(
          icon: Icon(Icons.search, color: ColorConstants.technicalServiceIcon),
        ),
        Tab(
          icon:
              Icon(Icons.favorite, color: ColorConstants.technicalServiceIcon),
        ),
        Tab(
          icon: Icon(Icons.account_box_rounded,
              color: ColorConstants.technicalServiceIcon),
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
    );
  }
}
