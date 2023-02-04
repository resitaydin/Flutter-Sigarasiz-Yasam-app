import 'package:flutter/material.dart';

class userInfo with ChangeNotifier {
  DateTime tarih;
  TimeOfDay saatDakika;
  double paketFiyat;
  double paketSigaraSayi;
  double gunlukSigara;
  double sabahKacdakikasonra;

  userInfo({
    required this.tarih,
    required this.saatDakika,
    required this.paketFiyat,
    required this.paketSigaraSayi,
    required this.gunlukSigara,
    required this.sabahKacdakikasonra,
  });
}
