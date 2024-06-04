import 'package:shared_preferences/shared_preferences.dart';
import 'package:oms/Constants/constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static SharedPreferences? _database;

  Future<SharedPreferences> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initdatabase();
    return _database!;
  }

  Future<SharedPreferences> _initdatabase() async {
    _database = await SharedPreferences.getInstance();
    return _database!;
  }

  Future<bool> get isDarkMode async {
    final daba = await instance.database;
    return daba.getBool(Constants.isDarkMode) ?? false;
  }

  Future<bool> setDarkMode(bool isDark) async {
    final db = await instance.database;
    return await db.setBool(Constants.isDarkMode, isDark);
  }

  Future<bool> get isEnglish async {
    final daba = await instance.database;
    return daba.getBool(Constants.isEnglish) ?? false;
  }

  Future<bool> setIsEnglish(bool isEnglish) async {
    final db = await instance.database;
    return await db.setBool(Constants.isEnglish, isEnglish);
  }

  Future<bool> get isJapanese async {
    final daba = await instance.database;
    return daba.getBool(Constants.isJapanese) ?? false;
  }

  Future<bool> setIsJapanese(bool isJapanese) async {
    final db = await instance.database;
    return await db.setBool(Constants.isJapanese, isJapanese);
  }

  Future<bool> get isVietnamese async {
    final daba = await instance.database;
    return daba.getBool(Constants.isVietnamese) ?? false;
  }

  Future<bool> setIsJa(bool isVietnamese) async {
    final db = await instance.database;
    return await db.setBool(Constants.isVietnamese, isVietnamese);
  }
}
