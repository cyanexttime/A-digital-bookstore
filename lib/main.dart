import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/screen/chapter.dart';
import 'package:oms/screen/chapter_content.dart';
import 'package:oms/screen/library_screen.dart';
import 'package:oms/screen/message_box_screen.dart';
import 'package:oms/screen/homePage.dart';
import 'package:oms/screen/introducePage.dart';
import 'package:oms/screen/login.dart';
import 'package:oms/screen/register.dart';
import 'package:oms/screen/resetpass.dart';
import 'package:oms/screen/search.dart';
import 'package:oms/components/SignIn_SignUp_Magadex/sign_in_magadex.dart';
import 'package:oms/components/SignIn_SignUp_Magadex/sign_up_mangadex.dart';
import 'firebase_options.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      title: 'OMS',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => myRegister(),
        'forgot': (context) => resetPassword(),
        'home': (context) => HomeScreen(),
        'introducePage': (context) => IntroducePage(),
        'searchScreen':(context) => searchScreen(),
        'chapterContent': (context) => ChapterContent(),
        'chapter': (context) => Chapter(),
        'signInMangadex': (context) => LoginFormDialog(),
        'signUpMangadex': (context) => RegisterFormDialog(),
        'library':(context) => LibraryScreen(),
      },
    ),
    );
}
