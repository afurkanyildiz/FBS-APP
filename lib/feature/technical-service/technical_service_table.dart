import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firat_bilgisayar_sistemleri/product/utility/exception/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../../product/constants/colors.dart';
import '../../product/constants/padding.dart';
import '../../product/models/technical_service.dart';

class TechnicalServiceTable extends StatefulWidget {
  const TechnicalServiceTable({super.key});

  @override
  State<TechnicalServiceTable> createState() => _TechnicalServiceTableState();
}

class _TechnicalServiceTableState extends State<TechnicalServiceTable> {
  @override
  Widget build(BuildContext context) {
    CollectionReference technicalService =
        FirebaseFirestore.instance.collection('technicalService');

    final response = technicalService.withConverter(
      fromFirestore: (snapshot, options) {
        return TechnicalService().fromFirebase(snapshot);
      },
      toFirestore: (value, options) {
        if (value == false) throw FirebaseCustomException('$value not null');
        return value.toJson();
      },
    ).get();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Teknik Servislerim",
          style: TextStyle(color: ColorConstants.colorsBlack),
        ),
        centerTitle: true,
        leading: BackButton(
          color: ColorConstants.colorsBlack,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: ColorConstants.colorsBlack,
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: response,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<TechnicalService?>> snapshot) {
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
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        elevation: 10,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: context.paddingLow,
                          child: Row(
                            children: [
                              Icon(Icons.computer),
                              Expanded(
                                child: Padding(
                                  padding: context.paddingLow,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: paddingBottom,
                                        child: Text(values[index]?.date ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                      Padding(
                                        padding: paddingBottom,
                                        child: Text(
                                            values[index]?.username ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                      Padding(
                                        padding: paddingBottom,
                                        child: Text(
                                            values[index]?.productBrand ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                      Padding(
                                        padding: paddingBottom,
                                        child: Text(
                                            values[index]?.complaint ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('İşlem Durumu',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    Card(
                                      elevation: 5,
                                      shape: BeveledRectangleBorder(
                                          borderRadius: cardBorderRadius),
                                      child: Padding(
                                        padding: context.paddingLow,
                                        child: Text(values[index]?.state ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ));
                  },
                );
              } else {
                return SizedBox();
              }
          }
        },
      ),
    );
  }
}
