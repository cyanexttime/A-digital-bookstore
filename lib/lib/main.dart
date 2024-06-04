import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oms/config/routes/routes.dart';
import 'package:oms/screen/settings_screen.dart';
import 'firebase_options.dart';
import 'package:oms/config/theme/app_theme.dart';
import 'package:oms/cubits/cubit_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Themecubit, ThemeMode>(
      builder: (context, state) {
        final themeMode = state;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SettingsScreen(),
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
