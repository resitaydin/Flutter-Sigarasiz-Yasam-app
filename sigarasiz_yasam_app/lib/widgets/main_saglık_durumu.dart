// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'dart:convert';

import 'package:smoke_quitter_app/screens/saglik_durumu_ayrintilar_screen.dart';
import '../modals/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class SaglikDurumu extends StatefulWidget {
  @override
  State<SaglikDurumu> createState() => _SaglikDurumuState();
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
      // print("userHour: $userHour");
      //     print("userMinutes: $userMinutes");
    });
  } catch (error) {}
}

class _SaglikDurumuState extends State<SaglikDurumu> {
  final _newUser = userInfo(
    tarih: DateTime.now(),
    saatDakika: TimeOfDay.now(),
    paketFiyat: 0.0,
    paketSigaraSayi: 1.0,
    gunlukSigara: 0.0,
    sabahKacdakikasonra: 0.0,
  );

  DateTime? remainingHoursMins;
  double? remainingMinsfromDays;

  var totalMins = 0.0;

  Timer? _timer;

  void initState() {
    var userHour = 0, userMinutes = 0;
    final _token = Provider.of<Auth>(context, listen: false).token;
    final _userId = Provider.of<Auth>(context, listen: false).userId;

    fetchData(_token!, _userId!, _newUser, userHour, userMinutes);
    print("userHour: $userHour");
    print("userMinutes: $userMinutes");

    super.initState();
    _timer = new Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) => setState(
        () {
          print("userHour: $userHour");
          print("userMinutes: $userMinutes");
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
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          color: Theme.of(context).backgroundColor,
          // ignore: prefer_const_constructors
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        "        Sağlık Durumu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 50),
                    CircularProgressBar(
                        " Nabız", (totalMins) / 20), //Nabız 20 dakika
                    CircularProgressBar(
                        " Nefes", (totalMins) / 4320), //Nefes 72 saat
                    CircularProgressBar(
                        "Dolaşım", (totalMins) / 50400), //kan dolaşımı 5 hafta
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 410),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                              SaglikAyrintilarScreen.routeName,
                              arguments: totalMins,
                            ),
                        child: Text("Daha Fazla Bilgi")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  String subtitleText;
  double percentage;

  CircularProgressBar(this.subtitleText, this.percentage);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircularPercentIndicator(
              radius: 60,
              lineWidth: 14,
              backgroundColor: Colors.white,
              percent: (percentage > 1.0) ? 1.0 : percentage,
              progressColor: Colors.blue,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              center: Text(
                (percentage >= 1.0)
                    ? "%100"
                    : "%${(percentage * 100).toStringAsFixed(1)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 55),
          ],
        ),
        SizedBox(height: 12),
        Text(
          subtitleText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
