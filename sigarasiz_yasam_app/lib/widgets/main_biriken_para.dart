// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_new, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import '../screens/birikim_ayrintilar_screen.dart';
import 'package:http/http.dart' as http;
import '../modals/user_info.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class BirikenPara extends StatefulWidget {
  @override
  State<BirikenPara> createState() => _BirikenParaState();
}

Future<void> fetchData(String token, String userId, userInfo _newUser,
    int userHour, int userMinutes) async {
  final url = Uri.parse(
      'https://flutter-sigarabirakmaapp-default-rtdb.europe-west1.firebasedatabase.app/userInfo/$userId.json?auth=$token');
  try {
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      _newUser.gunlukSigara = value['gunlukSigara'];
      _newUser.paketFiyat = value['paketFiyat'];
      _newUser.paketSigaraSayi = value['paketSigaraSayi'];
      // _newUser.saatDakika = TimeOfDay(
      //     hour: (double.parse((value['saatDakika']).split(":")[0])).toInt(),
      //     minute: (double.parse((value['saatDakika']).split(":")[1])).toInt());

      _newUser.tarih = DateTime.parse(value['tarih']);
      userHour = int.parse(value['saatDakika'].split(":")[0]);
      userMinutes = int.parse(value['saatDakika'].split(":")[1]);
    });
  } catch (error) {}
}

class _BirikenParaState extends State<BirikenPara> {
  final _newUser = userInfo(
    tarih: DateTime.now(),
    saatDakika: TimeOfDay.now(),
    paketFiyat: 0.0,
    paketSigaraSayi: 1.0,
    gunlukSigara: 0.0,
    sabahKacdakikasonra: 0.0,
  );

  var icilmeyenSigara = 0.0;
  var kazanilanYasamSuresi = 0.0;

  var birimSigaraFiyat = 0.0;

  var gunlukBirikenPara = 0.0, haftalikBirikenPara = 0.0;
  var aylikBirikenPara = 0.0, yillikBirikenPara = 0.0;
  var dakikaBirikenPara = 0.0;

  var totalMins = 0.0;

  DateTime? remainingHoursMins;

  double? remainingMinsfromDays;

  var guncelKar = 0.0;

  Timer? _timer;

  @override
  void initState() {
    final _token = Provider.of<Auth>(context, listen: false).token;
    final _userId = Provider.of<Auth>(context, listen: false).userId;

    var userHour = 0, userMinutes = 0;

    fetchData(_token!, _userId!, _newUser, userHour, userMinutes);

    super.initState();
    _timer = new Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => setState(
        () {
          final now = DateTime.now();

          final inputTime = DateTime(
            now.day,
            now.month,
            now.day,
            userHour,
            userMinutes,
          );

          remainingHoursMins = now.subtract(Duration(
            hours: userHour,
            minutes: userMinutes,
          ));

          var variable =
              _newUser.tarih.difference(now).inDays.abs().toDouble() * 1440;

          remainingMinsfromDays = (inputTime.isBefore(now) && variable != 0)
              ? variable - 1440
              : variable;
          //1 gün 1440 dakika

          totalMins = remainingHoursMins!.hour.toDouble() * 60 +
              remainingHoursMins!.minute.toDouble() +
              remainingMinsfromDays!;

          birimSigaraFiyat = _newUser.paketFiyat / _newUser.paketSigaraSayi;

          gunlukBirikenPara = birimSigaraFiyat * _newUser.gunlukSigara;
          dakikaBirikenPara = gunlukBirikenPara / 1440;
          haftalikBirikenPara = gunlukBirikenPara * 7;
          aylikBirikenPara = gunlukBirikenPara * 30;
          yillikBirikenPara = gunlukBirikenPara * 365;

          guncelKar = (dakikaBirikenPara * totalMins);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Widget build(BuildContext context) {
    icilmeyenSigara = (_newUser.gunlukSigara / 24.0) * (totalMins / 60.0);
    kazanilanYasamSuresi = 6 * (totalMins / 1440);

    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  "Biriken kazanç",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  (guncelKar.isNaN)
                      ? "0.00 ₺"
                      : "${guncelKar.toStringAsFixed(2)} ₺",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Aylık kazancınız ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (aylikBirikenPara.isNaN)
                      ? "0.00 ₺"
                      : "${aylikBirikenPara.toStringAsFixed(2)} ₺",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    BirikimAyrintilarScreen.routeName,
                    arguments: {
                      'guncelKar': guncelKar,
                      'gunlukKar': gunlukBirikenPara,
                      'haftalikKar': haftalikBirikenPara,
                      'aylikKar': aylikBirikenPara,
                      'yillikKar': yillikBirikenPara,
                    },
                  ),
                  child: const Text(
                    "Ayrıntılar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(120, 35),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          // Main ilerleme durumunuz container'ı
          height: 150,
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Text(
                "İlerlemeniz",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "İçmediğiniz Sigara Sayısı: ${icilmeyenSigara.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Geri Kazanılan Yaşam Süresi: ${kazanilanYasamSuresi.toStringAsFixed(1)} saat",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
