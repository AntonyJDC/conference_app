import 'package:conference_app/controllers/navbar_controller.dart';
import 'package:conference_app/ui/pages/favorites/favorites_screen.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:conference_app/ui/pages/search/search_page.dart';
import 'package:conference_app/ui/pages/booking/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final NavbarController navController = Get.put(NavbarController());

  final List<Widget> pages = [
    const HomeScreen(),
    const SearchPage(),
    const CalendarScreen(),
    const FavoritesPage(),
    const Center(child: Text('Historial')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final navBarItemWidth = constraints.maxWidth / 5;

          return Obx(() => Stack(
                children: [
                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: navController.currentIndex.value,
                    onTap: navController.changeTab,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Colors.grey,
                    backgroundColor: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Explore',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search_outlined),
                        activeIcon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today_outlined),
                        activeIcon: Icon(Icons.calendar_today),
                        label: 'Booking',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_border),
                        activeIcon: Icon(Icons.favorite),
                        label: 'Favorite',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history_outlined),
                        activeIcon: Icon(Icons.history),
                        label: 'History',
                      ),
                    ],
                  ),
                  // 🔵 Línea indicadora
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: (navBarItemWidth * navController.currentIndex.value) +
                        (navBarItemWidth - navBarItemWidth * 0.8) / 2,
                    bottom: kBottomNavigationBarHeight - 3,
                    child: Container(
                      width: navBarItemWidth * 0.8,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
