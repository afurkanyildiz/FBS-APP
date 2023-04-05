// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';

import 'package:firat_bilgisayar_sistemleri/product/constants/colors.dart';
import 'package:firat_bilgisayar_sistemleri/product/constants/string.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/small_title_text.dart';
import 'package:firat_bilgisayar_sistemleri/product/widget/text/subtitle_text.dart';

import '../../product/constants/padding.dart';
import '../../product/widget/card/store_view_small_card.dart';
import '../../product/widget/text/title_text.dart';

class StoreView extends StatelessWidget {
  const StoreView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: const [
          _Header(),
          _CampaignView(),
          _ChipView(),
          _SpecialForYouTitleWiew(),
          _SpecialForYouWiew(
            imagePath: 'assets/images/macbook.png',
          ),
          _PopularProductsTitleView(),
          _PopularProductsListView()
        ],
      ),
    );
  }
}

class _CampaignView extends StatelessWidget {
  const _CampaignView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(.14),
      child: Padding(
        padding: listPaddingHorizontal,
        child: Card(
          color: ColorConstants.mainbackgroundlinear1,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Padding(
            padding: paddingLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitleWhiteText(value: "Haftanın Kampanyası"),
                TitleWhiteText(value: "%25 İndirim!"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipView extends StatelessWidget {
  const _ChipView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(.15),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SmallCardView(
            icon: FontAwesomeIcons.boltLightning,
            title: 'Son\n Fırsatlar!',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.book,
            title: 'Servis\n Randevu',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.gamepad,
            title: 'Gamer\n Özel',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.gift,
            title: 'Hızlı\n Teslimat',
          ),
          SmallCardView(
            icon: FontAwesomeIcons.arrowPointer,
            title: 'Diğer\n Hizmetler',
          ),
        ],
      ),
    );
  }
}

class _SpecialForYouTitleWiew extends StatelessWidget {
  const _SpecialForYouTitleWiew({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: listPaddingHorizontal,
      child: Row(
        children: [
          Expanded(
            child: SmallTitleText(
              value: StringConstants.specialForYou,
            ),
          ),
          // Spacer(),
          TextButton(
            onPressed: () {},
            child: SubTitleText(
              value: StringConstants.seeAll,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialForYouWiew extends StatelessWidget {
  final String imagePath;

  const _SpecialForYouWiew({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.36,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Material(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/macbook.png'),
                          fit: BoxFit.cover)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PopularProductsTitleView extends StatelessWidget {
  const _PopularProductsTitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: listPaddingHorizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SmallTitleText(
              value: StringConstants.popularProducts,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: SubTitleText(
              value: StringConstants.seeAll,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularProductsListView extends StatelessWidget {
  const _PopularProductsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: listPaddingHorizontal,
            child: Row(
              children: [
                Expanded(
                  child: Placeholder(),
                ),
                Expanded(
                  child: Placeholder(),
                )
              ],
            ),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.onlyBottomPaddingMedium,
      child: Row(
        children: [
          Spacer(),
          _Title(),
          Spacer(
            flex: 8,
          ),
          _ShopCartIcon(),
          _NotificationsIcon(),
          Spacer()
        ],
      ),
    );
  }
}

class _NotificationsIcon extends StatelessWidget {
  const _NotificationsIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {}, icon: Icon(Icons.notifications_none_outlined));
  }
}

class _ShopCartIcon extends StatelessWidget {
  const _ShopCartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.shopping_cart_outlined,
        ));
  }
}

class _Title extends StatelessWidget {
  const _Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TitleText(
      value: StringConstants.homePage,
    );
  }
}
