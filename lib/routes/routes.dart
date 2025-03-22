import 'package:conference_app/ui/pages/search/search_page.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:conference_app/ui/pages/onBoarding/onboarding_screen.dart';
import 'package:conference_app/ui/widgets/bottom_nav_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String home = '/home';
  static const String main = '/main';
  static const String search = '/search';

  static List<GetPage> routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: main, page: () => BottomNavScreen()),
    GetPage(name: search, page: () => const SearchPage()),
  ];
}
