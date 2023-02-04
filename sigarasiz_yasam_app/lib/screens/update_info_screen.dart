// ignore_for_file: prefer_const_constructors, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smoke_quitter_app/screens/main_screen.dart';
import 'package:smoke_quitter_app/widgets/Date_Time_Picker.dart';
import '../modals/user_info.dart';
import 'package:intl/intl.dart';
import '../providers/auth.dart';

final _questions = [
  'En son ne zaman sigara içtiniz?', // Input: tarih
  'Bir paket sigara fiyatı?', //Input: sayı
  'Bir pakette kaç tane sigara var?', //Input: sayı
  'Bir günde kaç sigara içiyorsunuz?', //Input: sayı
  'Uyandıktan kaç dakika sonra ilk sigaranızı içiyorsunuz?', //Input: dakika
];

class UpdateInfo extends StatelessWidget {
  static const routeName = '/infoUpdate-screen';

  String? validator(String value) {
    if (value.isEmpty) {
      return "Alan boş bırakılamaz.";
    }
    if (double.parse(value) <= 0) {
      return "Geçersiz değer.";
    }
    if (double.tryParse(value) == null) {
      return "Geçersiz değer.";
    } //This does not work.
    return null;
  }

  var _newUser = userInfo(
    tarih: DateTime.now(),
    saatDakika: TimeOfDay.now(),
    paketFiyat: 0.0,
    paketSigaraSayi: 0.0,
    gunlukSigara: 0.0,
    sabahKacdakikasonra: 0.0,
  );

  final _form = GlobalKey<FormState>();

  void _saveForm(BuildContext context) {
    final _token = Provider.of<Auth>(context, listen: false).token;
    final _userId = Provider.of<Auth>(context, listen: false).userId;

    final url = Uri.parse(
        'https://flutter-sigarabirakmaapp-default-rtdb.europe-west1.firebasedatabase.app/userInfo/$_userId.json?auth=$_token');

    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState?.save();

    http
        .post(url,
            body: json.encode({
              'tarih': _newUser.tarih.toString(),
              'saatDakika':
                  "${_newUser.saatDakika.hour}:${_newUser.saatDakika.minute}",
              'gunlukSigara': _newUser.gunlukSigara,
              'paketFiyat': _newUser.paketFiyat,
              'paketSigaraSayi': _newUser.paketSigaraSayi,
              'userId': _userId,
            }))
        .then(
      (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kaydedildi.", textAlign: TextAlign.center),
            duration: Duration(seconds: 2),
          ),
        );
      },
    ).catchError((error) {
      print(error);
    });

    print(_newUser.tarih);
    print(_newUser.saatDakika);
    print(_newUser.gunlukSigara);
    print(_newUser.paketFiyat);
    print(_newUser.paketSigaraSayi);
    print(_newUser.sabahKacdakikasonra);

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    print("Bilgilerini guncelle ekranı");
    // final hours = _newUser.tarih.hour.toString().padLeft(2, '0');
    // final minutes = _newUser.tarih.minute.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bilgilerimi Güncelle"),
          actions: [
            IconButton(
              onPressed: () => _saveForm(context),
              icon: Icon(Icons.save),
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_newUser),
          ),
        ),
        body: Container(
          color: Color.fromARGB(221, 49, 219, 7),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  DateTimePicker(_newUser),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 19),
                    validator: (value) {
                      return validator(value!);
                    },
                    decoration: InputDecoration(
                      label: Text(
                        _questions[1],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Quicksand"),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _newUser = userInfo(
                        tarih: _newUser.tarih,
                        saatDakika: _newUser.saatDakika,
                        paketFiyat: double.parse(value!),
                        paketSigaraSayi: _newUser.paketSigaraSayi,
                        gunlukSigara: _newUser.gunlukSigara,
                        sabahKacdakikasonra: _newUser.sabahKacdakikasonra,
                      );
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 19),
                    validator: (value) {
                      return validator(value!);
                    },
                    decoration: InputDecoration(
                      label: Text(
                        _questions[2],
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _newUser = userInfo(
                        tarih: _newUser.tarih,
                        saatDakika: _newUser.saatDakika,
                        paketFiyat: _newUser.paketFiyat,
                        paketSigaraSayi: double.parse(value!),
                        gunlukSigara: _newUser.gunlukSigara,
                        sabahKacdakikasonra: _newUser.sabahKacdakikasonra,
                      );
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 19),
                    validator: (value) {
                      return validator(value!);
                    },
                    decoration: InputDecoration(
                      label: Text(
                        _questions[3],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _newUser = userInfo(
                        tarih: _newUser.tarih,
                        saatDakika: _newUser.saatDakika,
                        paketFiyat: _newUser.paketFiyat,
                        paketSigaraSayi: _newUser.paketSigaraSayi,
                        gunlukSigara: double.parse(value!),
                        sabahKacdakikasonra: _newUser.sabahKacdakikasonra,
                      );
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 19),
                    validator: (value) {
                      return validator(value!);
                    },
                    decoration: InputDecoration(
                      label: Text(
                        _questions[4],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    onSaved: (value) {
                      _newUser = userInfo(
                        tarih: _newUser.tarih,
                        saatDakika: _newUser.saatDakika,
                        paketFiyat: _newUser.paketFiyat,
                        paketSigaraSayi: _newUser.paketSigaraSayi,
                        gunlukSigara: _newUser.gunlukSigara,
                        sabahKacdakikasonra: double.parse(value!),
                      );
                    },
                    onFieldSubmitted: (_) => _saveForm(context),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveForm(context),
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
