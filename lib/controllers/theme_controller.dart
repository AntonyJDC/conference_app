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
    _setThemeMode(mode);
  }

  // Guardar el tema seleccionado en SharedPreferences
  Future<void> saveTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String value = _getThemeString(mode);

    selectedOption.value = mode;
    await prefs.setString('app_theme', value);
    _setThemeMode(value);
  }

  void _setThemeMode(String mode) {
    switch (mode) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }
    Get.changeThemeMode(themeMode.value);
  }

  String _getThemeString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
