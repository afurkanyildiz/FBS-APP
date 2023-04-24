import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/colors.dart';

class TechnicalServiceCreate extends StatefulWidget {
  const TechnicalServiceCreate({super.key});

  @override
  State<TechnicalServiceCreate> createState() => _TechnicalServiceCreateState();
}

class _TechnicalServiceCreateState extends State<TechnicalServiceCreate> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephone_numberController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController product_brandController = TextEditingController();
  TextEditingController product_modelController = TextEditingController();
  TextEditingController complaintsController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teknik Servislerim",
          style: TextStyle(color: ColorConstants.colorsBlack),
        ),
        centerTitle: true,
        leading: BackButton(
          color: ColorConstants.colorsBlack,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      labelText: "AD - SOYAD",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "E-MAİL",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: telephone_numberController,
                  decoration: InputDecoration(
                      labelText: "TELEFON NUMARASI",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: adressController,
                  decoration: InputDecoration(
                      labelText: "ADRES",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: context.paddingLow,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: countryController,
                        decoration: InputDecoration(
                            labelText: "İL",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: context.paddingLow,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                            labelText: "İLÇE",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: context.paddingLow,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: product_brandController,
                        decoration: InputDecoration(
                            labelText: "ÜRÜNÜN MARKASI",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: context.paddingLow,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: product_modelController,
                        decoration: InputDecoration(
                            labelText: "ÜRÜNÜN MODELİ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: complaintsController,
                  decoration: InputDecoration(
                      labelText: "AÇIKLAMA",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: "TARİH",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
