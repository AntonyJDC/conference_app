import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

class ThemeController extends GetxController {
  final themeMode = ThemeMode.system.obs;
  final selectedOption = AppThemeMode.system.obs;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('app_theme') ?? 'system';
    switch (mode) {
      case 'light':
        themeMode.value = ThemeMode.light;
        selectedOption.value = AppThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        selectedOption.value = AppThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
        selectedOption.value = AppThemeMode.system;
    }
  }

  Future<void> saveTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String value;
    switch (mode) {
      case AppThemeMode.light:
        value = 'light';
        themeMode.value = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        value = 'dark';
        themeMode.value = ThemeMode.dark;
        break;
      default:
        value = 'system';
        themeMode.value = ThemeMode.system;
    }
    selectedOption.value = mode;
    await prefs.setString('app_theme', value);
    Get.changeThemeMode(themeMode.value);
  }
}
