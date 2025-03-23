import 'package:conference_app/ui/pages/search/search_page.dart';
import 'package:conference_app/ui/pages/booking//calendar_screen';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/navbar_controller.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';
import 'package:time_planner/time_planner.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final NavbarController controller = Get.put(NavbarController());

  final List<Widget> pages = [
    HomeScreen(),
    SearchPage(),
    CalendarScreen(tasks: tasks),
    Center(child: Text('Favoritos')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    final navBarItemWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => Stack(
            children: [
              SizedBox(
                height: 65,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.currentIndex.value,
                  onTap: controller.changeTab,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Colors.grey,
                  backgroundColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Explore'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search_outlined),
                        activeIcon: Icon(Icons.search),
                        label: 'Search'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today_outlined),
                        activeIcon: Icon(Icons.calendar_today),
                        label: 'Booking'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_border),
                        activeIcon: Icon(Icons.favorite),
                        label: 'Favorite'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        activeIcon: Icon(Icons.person),
                        label: 'Profile'),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: (navBarItemWidth * controller.currentIndex.value) +
                    (navBarItemWidth - navBarItemWidth * 0.8) / 2,
                bottom: 65 - 3,
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
          )),
    );
  }
}

List<TimePlannerTask> tasks = [
  TimePlannerTask(
    color: Colors.purple,
    dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 30),
    minutesDuration: 90,
    daysDuration: 1,
    onTap: () {},
    child: Text(
      'Meeting with team',
      style: TextStyle(color: Colors.grey[350], fontSize: 12),
    ),
  ),
  TimePlannerTask(
    color: Colors.blue,
    dateTime: TimePlannerDateTime(day: 1, hour: 10, minutes: 0),
    minutesDuration: 60,
    daysDuration: 1,
    onTap: () {},
    child: Text(
      'Client presentation',
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  ),
  TimePlannerTask(
    color: Colors.green,
    dateTime: TimePlannerDateTime(day: 2, hour: 16, minutes: 15),
    minutesDuration: 45,
    daysDuration: 1,
    onTap: () {},
    child: Text(
      'Code review',
      style: TextStyle(color: Colors.black, fontSize: 12),
    ),
  ),
];
