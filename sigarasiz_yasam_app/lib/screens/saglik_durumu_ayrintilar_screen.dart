// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SaglikAyrintilarScreen extends StatelessWidget {
  // ignore: unused_field
  final _saglikParametre = {
    "Nabız",
    "Kan oksijen düzeyi",
    "Karbonmonoksit düzeyi",
    "Nefes",
    "Kan Dolaşımı",
    "Azalmış kalp krizi riski"
  };

  final _saglikAciklama = {
    "Son sigaradan yaklaşık 20 dakika sonra kan basıncı ve nabız normale döner.",
    "Son sigaradan tahmini 8 saat sonra kan oksijen düzeyi normale döner.",
    "Son sigaradan ortalama 24 saat sonra vücut karbonmonoksitten arınır.",
    "Son sigaradan yaklaşık 72 saat sonra nefes alma normale döner.",
    "Son sigaradan ortalama 2-12 hafta sonra kan dolaşımı normale döner.",
    "Son sigaradan yaklaşık 10-15 yıl sonra kalp krizi geçirme riski normale döner."
  };

  // Nabız 20 dakika
  // Kan oksijen düzeyi 8 saat sonra.
  // vücut karbonmonoksitten arınır 24 saat.
  // Nefes 72 saat
  // Kan dolaşımı 5 hafta
  // Kalp krizi riski 10 yıl.

  static const routeName = '/saglik-ayrintilar';

  @override
  Widget build(BuildContext context) {
    final totalMins = ModalRoute.of(context)!.settings.arguments as double;

    final _saglikSure = {
      totalMins / 20, //20 dakika
      totalMins / (8 * 60), // 8 saat
      totalMins / (24 * 60), //24 saat
      totalMins / (72 * 60), //72 saat
      totalMins / (35 * 24 * 60), //5 hafta(35 gün)
      totalMins / (10 * 365 * 24 * 60), //10 yıl
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sağlık Durumum"),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 250,
            child: Card(
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 40,
                      child: Text(
                        _saglikParametre.elementAt(index),
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  CircularPercentIndicator(
                    lineWidth: 13,
                    radius: 63,
                    percent: (_saglikSure.elementAt(index) > 1.0)
                        ? 1.0
                        : _saglikSure.elementAt(index),
                    progressColor: Colors.blue,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      (_saglikSure.elementAt(index) >= 1.0)
                          ? "%100"
                          : "%${(_saglikSure.elementAt(index) * 100).toStringAsFixed(1)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        _saglikAciklama.elementAt(index),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
