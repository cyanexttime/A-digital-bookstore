import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/chapter.dart';
import 'package:oms/chapter_content.dart';
import 'package:oms/homePage.dart';
import 'package:oms/screen/homePage.dart';
import 'package:oms/screen/introducePage.dart';
import 'package:oms/screen/login.dart';
import 'package:oms/screen/register.dart';
import 'package:oms/screen/resetpass.dart';
import 'package:oms/search.dart';
import 'package:oms/sign_in_magadex.dart';
import 'package:oms/sign_up_mangadex.dart';
import 'firebase_options.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'signInMagadex',
      title: 'OMS',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => myRegister(),
        'forgot': (context) => resetPassword(),
        'home': (context) => const HomeScreen(),
        'introducePage': (context) => IntroducePage(),
        'searchScreen':(context) => SearchScreen(),
        'chapterContent': (context) => ChapterContent(),
        'chapter': (context) => Chapter(),
        'signInMagadex': (context) => LoginFormDialog(),
        'signUpMagadex': (context) => RegisterFormDialog(),
      },
    ),
  );
}
