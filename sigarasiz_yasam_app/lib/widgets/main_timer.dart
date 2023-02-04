// ignore_for_file: unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:smoke_quitter_app/modals/user_info.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';

class CountUp extends StatefulWidget {
  @override
  State<CountUp> createState() => CountUpState();
}

Future<void> fetchData(String token, String userId, userInfo newUser,
    int userHour, int userMinutes) async {
  final url = Uri.parse(
      'https://flutter-sigarabirakmaapp-default-rtdb.europe-west1.firebasedatabase.app/userInfo/$userId.json?auth=$token');
  try {
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      newUser.gunlukSigara = value['gunlukSigara'];
      newUser.paketFiyat = value['paketFiyat'];
      newUser.paketSigaraSayi = value['paketSigaraSayi'];

      newUser.tarih = DateTime.parse(value['tarih']);
      userHour = int.parse(value['saatDakika'].split(":")[0]);
      userMinutes = int.parse(value['saatDakika'].split(":")[1]);
      // print("Tarih: ${value['tarih']}");
      // print("userHour: $userHour");
      // print("userMinutes: $userMinutes");
    });
  } catch (error) {}
}

class CountUpState extends State<CountUp> {
  Timer? _timer;

  var remainingDays = 0.0;
  DateTime? remainingHoursMins;
  var hours = 0, minutes = 0;
  // ignore: prefer_final_fields
  var _newUser = userInfo(
    tarih: DateTime.now(),
    saatDakika: TimeOfDay.now(),
    paketFiyat: 0.0,
    paketSigaraSayi: 1.0,
    gunlukSigara: 0.0,
    sabahKacdakikasonra: 0.0,
  );

  @override
  void initState() {
    print("initializing");
    var userHour = 0, userMinutes = 0;
    double remainingMinsfromDays;

    final token = Provider.of<Auth>(context, listen: false).token;
    final userId = Provider.of<Auth>(context, listen: false).userId;

    fetchData(token!, userId!, _newUser, userHour, userMinutes);

    print("initstate");
    super.initState();
    _timer = new Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) => setState(
        () {
          print("inside setState");

          final now = DateTime.now();

          final inputTime =
              DateTime(now.day, now.month, now.day, userHour, userMinutes);

          remainingHoursMins = now.subtract(Duration(
            hours: userHour,
            minutes: userMinutes,
          ));

          // print("userHour inside setstate: $userHour ");
          // print(userMinutes);

          var variable =
              _newUser.tarih.difference(now).inDays.abs().toDouble() * 1440;

          remainingMinsfromDays = (inputTime.isBefore(now) && variable != 0)
              ? variable - 1440
              : variable;
          //1 gün 1440 dakika

          hours = remainingHoursMins!.hour;
          minutes = remainingHoursMins!.minute;

          remainingDays = remainingMinsfromDays / 1440;
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
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Text(
          '${remainingDays.toStringAsFixed(0)} g :$hours s :$minutes d',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
