import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/routes/routes.dart';
import 'package:conference_app/ui/theme/app_colors.dart';
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
    final materialTheme = MaterialTheme(ThemeData().textTheme);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: onboardingSeen ? AppRoutes.main : AppRoutes.onboarding,
      getPages: AppRoutes.routes,
      themeMode: ThemeMode.system,

      // 🌞 Tema Claro
      theme: materialTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'Mulish',
                ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),

      // 🌙 Tema Oscuro
      darkTheme: materialTheme.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Mulish',
                ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),
    );
  }
}
