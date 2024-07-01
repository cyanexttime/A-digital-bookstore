import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/config/theme/app_theme.dart';
import 'package:oms/screen/chapter.dart';
import 'package:oms/screen/chapter_content.dart';
import 'package:oms/screen/library_screen.dart';
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      title: 'OMS',
      routes: {
        'login': (context) => const MyLogin(),
        'register': (context) => const myRegister(),
        'forgot': (context) => const resetPassword(),
        'home': (context) => const HomeScreen(),
        'introducePage': (context) => const IntroducePage(),
        'searchScreen': (context) => const searchScreen(),
        'chapterContent': (context) => const ChapterContent(),
        'chapter': (context) => const Chapter(),
        'signInMangadex': (context) => const LoginFormDialog(),
        'signUpMangadex': (context) => const RegisterFormDialog(),
        'library': (context) => const LibraryScreen(),
      },
    ),
  );
}
