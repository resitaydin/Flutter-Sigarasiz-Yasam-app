// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:async';

class BirikimAyrintilarScreen extends StatelessWidget {
  static const routeName = '/savedmoneydetails';

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    print(arguments);

    final _condition = arguments.isEmpty || (arguments['yillikKar']).isNaN;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Toplam Birikimim"),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.topCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blue,
              child: Text(
                (_condition)
                    ? "0.00 ₺"
                    : "${(arguments['guncelKar']).toStringAsFixed(2)} ₺",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          myContainer(
              (_condition)
                  ? "Günlük : 0.00 ₺"
                  : "Günlük : ${(arguments['gunlukKar']).toStringAsFixed(2)} ₺",
              30),
          myContainer(
              (_condition)
                  ? "Haftalık : 0.00 ₺"
                  : "Haftalık : ${(arguments['haftalikKar']).toStringAsFixed(2)} ₺",
              30),
          myContainer(
              (_condition)
                  ? "Aylık : 0.00 ₺"
                  : "Aylık : ${(arguments['aylikKar']).toStringAsFixed(2)} ₺",
              30),
          myContainer(
              (_condition)
                  ? "Yıllık : 0.00 ₺"
                  : "Yıllık : ${(arguments['yillikKar']).toStringAsFixed(2)} ₺",
              30),
        ],
      ),
    );
  }
}

class myContainer extends StatelessWidget {
  String myText;
  double fontSize;

  myContainer(this.myText, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.blue,
        child: Text(
          myText,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
