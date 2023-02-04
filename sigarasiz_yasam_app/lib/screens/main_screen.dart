// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smoke_quitter_app/modals/user_info.dart';
import 'package:smoke_quitter_app/widgets/main_motive_soz.dart';
import 'package:smoke_quitter_app/widgets/main_saglık_durumu.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'update_info_screen.dart';
import '../widgets/main_timer.dart';
import '../widgets/main_biriken_para.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _newUser = userInfo(
    tarih: DateTime.now(),
    saatDakika: TimeOfDay.now(),
    paketFiyat: 0.0,
    paketSigaraSayi: 1.0,
    gunlukSigara: 0.0,
    sabahKacdakikasonra: 0.0,
  );

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateInfo(),
      ),
    );
    setState(() {
      _newUser = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text("Sigarasız Yaşam"),
          actions: [
            Builder(builder: (ctx) {
              return PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 0) {
                    _navigateAndDisplaySelection(ctx);
                  } else if (value == 1) {
                    Provider.of<Auth>(context, listen: false).logout();
                  }
                },
                itemBuilder: ((context) => [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          "Ayarlar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          "Çıkış Yap",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              );
            }),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Kronometre-Eski.jpg'),
              ),
              color: Color.fromARGB(255, 8, 156, 10),
            ),
          ),
          Container(
            height: 100,
            color: Colors.black87,
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  "Sigarasız geçen süre: ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                CountUp(),
              ],
            ),
          ),
          MotiveSoz(),
          BirikenPara(),
          SaglikDurumu(),
        ],
      ),
    );
  }
}
