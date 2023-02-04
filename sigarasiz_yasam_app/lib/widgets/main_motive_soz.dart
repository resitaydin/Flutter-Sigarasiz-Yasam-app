// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

var _MotiveSozler = [
  "Sigarayı dışla, hayata yeniden başla!",
  "Özleminiz geçicidir, ancak ciğerlerinizdeki hasar kalıcıdır.",
  "Sigarayı atın, hayatı tadın.",
  "Sigara içmek, hayatınızı kısaltmak için para ödemek gibidir.",
  "Bir dal aldım arkadaşımdan, alıkoydu beni hayatımdan. -Melike Balcı",
  "Zararlı alışkanlıklardan en güzel korunma yolu hiç başlamamaktır.",
  "Sigarayı bırakmanın ilk şartı gerçekten istemektir.",
  // "Sigara önce süründürür, sonra öldürür.",
  // "Sigara ağız tadının, sağlığın, her şeyin düşmanıdır.",
];

class MotiveSoz extends StatefulWidget {
  @override
  State<MotiveSoz> createState() => _MotiveSozState();
}

class _MotiveSozState extends State<MotiveSoz> {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    final today = DateTime.now().weekday.toInt();
    setState(() {
      index = today;
    });

    return Container(
      color: Color.fromARGB(255, 8, 156, 10),
      height: 100,
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4),
      child: Text(
        _MotiveSozler[index - 1],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontFamily: 'Quicksand',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
