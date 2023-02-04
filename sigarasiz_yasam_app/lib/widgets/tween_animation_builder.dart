import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  var daysDif = 0;
  var hoursDif = 0;
  var minutesDif = 0;

  Stopwatch(this.daysDif, this.minutesDif, this.hoursDif);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  int? days, hours, minutes;

  @override
  Widget build(BuildContext context) {
    setState(() {
      days = widget.daysDif;
      hours = widget.hoursDif;
      minutes = widget.minutesDif;
      print(days);
      print(hours);
      print(minutes);
    });

    return TweenAnimationBuilder<Duration>(
      duration: const Duration(days: 999),
      tween: Tween(
        begin: Duration(
          days: days as int,
          hours: hours as int,
          minutes: minutes as int,
        ),
        end: const Duration(days: 999),
      ),
      onEnd: () {
        print('Timer ended');
      },
      builder: (BuildContext context, Duration value, Widget? child) {
        final days = value.inDays;
        final hours = value.inHours % 24;
        final minutes = value.inMinutes % 60;
        final seconds = value.inSeconds % 60;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '$days g:$hours s:$minutes d',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
          ),
        );
      },
    );
  }
}
