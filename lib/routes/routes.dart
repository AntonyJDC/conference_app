import 'package:conference_app/ui/pages/event/event_detail_page.dart';
import 'package:conference_app/ui/pages/event/event_list_page.dart';
import 'package:conference_app/ui/pages/favorites/favorites_screen.dart';
import 'package:conference_app/ui/pages/notifications/notifications_screen.dart';
import 'package:conference_app/ui/pages/reviews/widgets/see_all_reviews.dart';
import 'package:conference_app/ui/pages/search/search_page.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:conference_app/ui/pages/onBoarding/onboarding_screen.dart';
import 'package:conference_app/ui/widgets/bottom_nav_screen.dart';
import 'package:conference_app/ui/pages/category/category_screen.dart';
import 'package:conference_app/ui/pages/reviews/reviews_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String home = '/home';
  static const String main = '/main';
  static const String search = '/search';
  static const String detail = '/detail';
  static const String category = '/category';
  static const String favorite = '/favorite';
  static const String notifications = '/notifications';
  static const String nearby =
      '/nearby'; // Asegúrate de que esta constante exista

  static List<GetPage> routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: main, page: () => BottomNavScreen()),
    GetPage(name: search, page: () => const SearchPage()),
    GetPage(name: detail, page: () => const EventDetailPage()),
    GetPage(name: favorite, page: () => const FavoritesPage()),
    GetPage(name: category, page: () => const CategoryScreen()),
    GetPage(name: notifications, page: () => NotificationsScreen()),
    GetPage(
      name: nearby,
      page: () {
        final args = Get.arguments;
        return EventListPage(
          title: args['title'] ?? 'Eventos',
          emptyMessage: args['emptyMessage'] ?? 'No hay eventos disponibles.',
          events: args['events'] ?? [],
        );
      },
    ),
    GetPage(name: '/reviews', page: () => const ReviewsScreen()),
    GetPage(
      name: '/event/reviews',
      page: () => EventAllReviewsPage(event: Get.arguments),
    ),
  ];
}
