import 'package:financial_app/views/access/login.dart';
import 'package:financial_app/views/access/register.dart';

import 'package:financial_app/views/home_page.dart';
import 'package:financial_app/views/route_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      title: 'FIDARE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Khang',
      ),
      home: //HomePage(),
          /*StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),*/
          auth.currentUser == null ? LoginPage() : HomePage(),
      routes: {
        '/homePage': (context) => HomePage(),
      },
      //initialRoute: '/',
    );
  }
}
