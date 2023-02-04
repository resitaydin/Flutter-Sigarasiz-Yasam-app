// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smoke_quitter_app/screens/birikim_ayrintilar_screen.dart';
import 'package:smoke_quitter_app/screens/saglik_durumu_ayrintilar_screen.dart';
import 'package:smoke_quitter_app/screens/update_info_screen.dart';
import 'screens/main_screen.dart';
import './widgets/Navigation_Bar.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Sigarasız Yaşam',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: Color.fromARGB(255, 8, 156, 10),
            fontFamily: 'Quicksand',
          ),
          home: auth.isAuth
              ? MyNavigationBar()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          initialRoute: '/',
          routes: {
            UpdateInfo.routeName: (ctx) => UpdateInfo(),
            BirikimAyrintilarScreen.routeName: (context) =>
                BirikimAyrintilarScreen(),
            SaglikAyrintilarScreen.routeName: (ctx) => SaglikAyrintilarScreen(),
          },
        ),
      ),
    );
  }
}
