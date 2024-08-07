import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/config/routes/routes.dart';
import 'package:oms/screen/settings_screen.dart';
import 'package:oms/config/theme/app_theme.dart';
import 'package:oms/cubits/cubit_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oms/provider/bookmark_model.dart';
import 'package:oms/provider/chapter_model.dart';
import 'package:oms/screen/bookmarks_page.dart';
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
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Themecubit(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BookmarkBloc()),
          ChangeNotifierProvider(create: (context) => ChapterInfoProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Themecubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OMS',
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: 'introducePage',
          routes: {
            'login': (context) => const MyLogin(),
            'register': (context) => const MyRegister(),
            'forgot': (context) => const ResetPassword(),
            'home': (context) => const HomeScreen(),
            'introducePage': (context) => const IntroducePage(),
            'searchScreen': (context) => const SearchScreen(),
            'chapterContent': (context) => const ChapterContent(),
            'chapter': (context) => const Chapter(),
            'signInMangadex': (context) => const LoginFormDialog(),
            'signUpMangadex': (context) => const RegisterFormDialog(),
            'library': (context) => const LibraryScreen(),
            'bookmarkPage': (context) => const BookmarksPage(),
            'settings': (context) => const SettingsScreen(),
          },
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
