import 'package:flutter/material.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:conference_app/ui/pages/onBoarding/onboarding_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
