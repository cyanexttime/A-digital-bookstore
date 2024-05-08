import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/screen/homePage.dart';
import 'package:oms/screen/introducePage.dart';
import 'package:oms/screen/login.dart';
import 'package:oms/screen/register.dart';
import 'package:oms/screen/resetpass.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'introducePage',
      title: 'OMS',
      routes: {
        'login': (context) => const MyLogin(),
        'register': (context) => const myRegister(),
        'forgot': (context) => const resetPassword(),
        'home': (context) => const HomeScreen(),
        'introducePage': (context) => const IntroducePage(),
      },
    ),
  );
}
