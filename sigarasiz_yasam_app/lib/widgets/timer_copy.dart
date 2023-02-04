// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:smoke_quitter_app/modals/user_info.dart';

class CountUp extends StatefulWidget {
  userInfo _newUser;
  CountUp(this._newUser);

  @override
  State<CountUp> createState() => CountUpState();
}

class CountUpState extends State<CountUp> {
  Timer? _timer;

  var remainingDays = 0;
  DateTime? remainingHoursMins;
  var hours = 0, minutes = 0;

  @override
  void initState() {
    print("initstate");
    super.initState();
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          final now = DateTime.now();

          final inputTime = DateTime(
              now.day,
              now.month,
              now.day,
              widget._newUser.saatDakika.hour,
              widget._newUser.saatDakika.minute);

          remainingHoursMins = now.subtract(Duration(
            hours: widget._newUser.saatDakika.hour,
            minutes: widget._newUser.saatDakika.minute,
          ));

          var variable = widget._newUser.tarih.difference(now).inDays.abs();

          remainingDays = variable;

          hours = remainingHoursMins!.hour;
          minutes = remainingHoursMins!.minute;
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
          '$remainingDays g :$hours s :$minutes d',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
        ),
      ),
    );
  }
}
