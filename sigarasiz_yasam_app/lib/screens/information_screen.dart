// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class informationScreen extends StatelessWidget {
  final _sigaraZararlariBaslik = {
    'Kanser',
    'Kalp Hastalıkları',
    'Solunum Hastalıkları',
    'Böbrek Hastalıkları',
    'Diyabet',
    'Depresyon',
    'Erken Yaşlanma',
    'Kısırlık',
  };

  final _sigaraZararlari = [
    "Sigara tüketen bir insanın kanser ile ilişkili herhangi bir hastalık sonucunda hayatını kaybetme riski 7 kat artarken, akciğer kanseri ile ilişkili ölüm riski 12 ila 24 kat artış gösterir.",
    "Sigara tüketen kişilerin kalp krizi gibi kardiyovasküler hastalıklar sonucunda hayatını kaybetme riski sigara tüketmeyenlere göre 4 kat daha fazladır.",
    "Uzun süre sigara kullanımı sonucunda KOAH riskinin %8'den fazla artış gösterdiği söylenebilir.",
    "Sigara ile ortaya çıkan kan basıncı artışı uzun vadede böbrekler üzerinde ciddi hasarlara ve hatta böbrek yetmezliği tablosuna yol açabilir.",
    "Geçmişte sigara kullanan kişilerin tip 2 diyabet hastalığına yakalanma riski %28 oranında artış gösterirken bu sayı halihazırda sigara kullanmaya devam eden kişiler için çok daha yüksektir.",
    "Sigara tüketimi vücudun tüm sistemlerinde olduğu gibi ruh sağlığı üzerinde de fazlasıyla zararlı etkiler gösterir. Sigara tüketen veya pasif içici olarak sigara dumanına maruz kalan kişilerde depresif belirtiler çok daha fazla görülür ve özellikle nikotin düzeyinin hızlı şekilde artıp azalması kişinin depresyona olan yatkınlığını büyük oranda artırır.",
    "Düzenli bir şekilde sigara içilmesi, deri yapısını bozar, kırışıklıklara yol açar. Bunun yanında dişler sararır ve de kararır, tırnaklar sağlıksızlaşır.",
    "Çiftlerden sadece birinin sigara içmesi çocuk olmaması riskini tam 3 kat arttırır."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(title: Text("Sigaranın Zararları")),
      body: Container(
        child: ListView.builder(
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.amberAccent,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _sigaraZararlariBaslik.elementAt(index),
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _sigaraZararlari.elementAt(index),
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
