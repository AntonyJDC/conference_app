import 'package:conference_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conference App',

      // 🌓 Detecta el modo del sistema (light/dark)
      themeMode: ThemeMode.system,

      // 🌞 Tema claro
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.lightPrimary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.lightPrimary,
          secondary: AppColors.lightSecondary,
          background: AppColors.lightBackground,
          surface: AppColors.lightSurface,
          error: AppColors.lightError,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.lightText,
          onBackground: AppColors.lightText,
          onError: Colors.white,
        ),
      ),

      // 🌙 Tema oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.darkPrimary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.darkPrimary,
          secondary: AppColors.darkSecondary,
          background: AppColors.darkBackground,
          surface: AppColors.darkSurface,
          error: AppColors.darkError,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.darkText,
          onBackground: AppColors.darkText,
          onError: Colors.white,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
