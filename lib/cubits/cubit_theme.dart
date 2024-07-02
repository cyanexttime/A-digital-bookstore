import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oms/database_helper/data_help.dart';

class Themecubit extends Cubit<ThemeMode> {
  Themecubit() : super(ThemeMode.system) {
    _getCurrentTheme();
  }

  bool get isDarkMode => state == ThemeMode.dark;
  Future<void> _getCurrentTheme() async {
    final isDarkMode = await DatabaseHelper.instance.isDarkMode;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> changeTheme({required bool isDarkMode}) async {
    await DatabaseHelper.instance.setDarkMode(isDarkMode);
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<bool> getIsDarkMode() async {
    final isDark = await DatabaseHelper.instance.isDarkMode;
    return isDark;
  }
}
