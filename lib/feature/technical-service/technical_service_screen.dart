import 'package:firat_bilgisayar_sistemleri/feature/technical-service/technical_service_create.dart';
import 'package:firat_bilgisayar_sistemleri/feature/technical-service/technical_service_table.dart';
import 'package:flutter/material.dart';
import '../../product/constants/colors.dart';
import '../home/home.dart';

class TechnicalServiceScreen extends StatefulWidget {
  const TechnicalServiceScreen({super.key});

  @override
  State<TechnicalServiceScreen> createState() => _TechnicalServiceScreenState();
}

class _TechnicalServiceScreenState extends State<TechnicalServiceScreen>
    with NavigatorManager {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ScaffoldTechnicalServiceWidget(context),
    );
  }

  Scaffold ScaffoldTechnicalServiceWidget(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingButtonWidget(context),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomAppBarWidget(),
      // appBar: AppBarWidget(),
      body: TabBarView(children: [
        TechnicalServiceTable(),
        TechnicalServiceCreate(),
      ]),
    );
  }

  BottomAppBar BottomAppBarWidget() {
    return BottomAppBar(
      surfaceTintColor: ColorConstants.colorsBlack,
      notchMargin: 10,
      shape: CircularNotchedRectangle(),
      child: TabBar(tabs: [
        Tab(
          icon: Icon(
            Icons.table_chart,
            color: ColorConstants.technicalServiceIcon,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.add,
            color: ColorConstants.technicalServiceIcon,
          ),
        ),
      ]),
    );
  }

  FloatingActionButton FloatingButtonWidget(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      backgroundColor: ColorConstants.technicalServiceIcon,
      child: Icon(Icons.view_stream),
    );
  }
}
