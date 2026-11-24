import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pilihanWarnaTema = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.purple,
];

class PengaturanState {
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final seedColor = ValueNotifier<Color>(Colors.teal);
  static final targetHarian = ValueNotifier<int>(20000);

  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final colorValue = prefs.getInt('seedColor') ?? Colors.teal.toARGB32();
    final target = prefs.getInt('targetHarian') ?? 20000;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    seedColor.value = Color(colorValue);
    targetHarian.value = target;
  }

  static Future<void> setDarkMode(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  static Future<void> setSeedColor(Color color) async {
    seedColor.value = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seedColor', color.toARGB32());
  }

  static Future<void> setTargetHarian(int target) async {
    targetHarian.value = target;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('targetHarian', target);
  }
}
