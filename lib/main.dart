import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/homePage.dart';
import 'package:oms/introducePage.dart';
import 'package:oms/login.dart';
import 'package:oms/register.dart';
import 'package:oms/resetpass.dart';
import 'package:oms/search.dart';
import 'firebase_options.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'searchScreen',
      title: 'OMS',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => myRegister(),
        'forgot': (context) => resetPassword(),
        'home': (context) => HomePage(),
        'introducePage': (context) => IntroducePage(),
        'searchScreen':(context) => SearchScreen(),
      },
    ),
  );
}
