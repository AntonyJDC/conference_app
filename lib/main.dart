import 'package:flutter/material.dart';
import 'package:conference_app/ui/pages/onBoarding/onboarding_screen.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

  runApp(MyApp(onboardingSeen: onboardingSeen));
}

class MyApp extends StatelessWidget {
  final bool onboardingSeen;
  const MyApp({super.key, required this.onboardingSeen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conference App',
      themeMode: ThemeMode.system,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: onboardingSeen ? const HomeScreen() : const OnboardingScreen(),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Mulish',
      colorSchemeSeed: const Color.fromARGB(
          255, 3, 31, 196), // 🎨 Seed para generar la paleta
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF3F51B5),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Mulish',
      colorSchemeSeed: const Color.fromARGB(
          255, 196, 250, 0), // 🎨 Seed diferente para dark mode
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF5C6BC0),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
