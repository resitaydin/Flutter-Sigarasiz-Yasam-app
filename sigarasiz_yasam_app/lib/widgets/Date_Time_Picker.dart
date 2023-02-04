// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modals/user_info.dart';

class DateTimePicker extends StatefulWidget {
  userInfo _newUser;
  DateTimePicker(this._newUser);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        } else {
          setState(() {
            widget._newUser.tarih = pickedDate;
          });
        }
      });
    }

    Future<TimeOfDay?> _pickTime() {
      return showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: TimeOfDay.now().hour,
          minute: TimeOfDay.now().minute,
        ),
      ).then((value) {
        if (value == null) {
          return;
        } else {
          setState(() {
            widget._newUser.saatDakika = value;
          });
        }
      });
    }

    return Row(
      children: [
        Expanded(
          child: const Text(
            "En son ne zaman sigara içtiniz?",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              fontFamily: "Quicksand",
            ),
          ),
        ),
        TextButton(
          onPressed: () => _presentDatePicker(),
          child: Text(
            DateFormat.yMd().format(widget._newUser.tarih),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _pickTime(),
          child: Text(
            MaterialLocalizations.of(context)
                .formatTimeOfDay(widget._newUser.saatDakika),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
