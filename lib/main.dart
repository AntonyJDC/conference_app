import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/controllers/review_controller.dart';
import 'package:conference_app/domain/use_case/events/initialize_events_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:conference_app/routes/routes.dart';
import 'package:conference_app/ui/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:conference_app/controllers/theme_controller.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

  // Cargar el tema guardado de SharedPreferences
  final savedThemeMode = prefs.getString('theme_mode');
  final themeController = Get.put(ThemeController());

  Get.put(BookedEventsController());
  Get.put(FavoriteController());
  Get.put(ReviewController());

  await themeController.loadTheme();
  await initializeDateFormatting('es_CO', null);
  await InitializeEventsUseCase().execute();

  runApp(MyApp(
    onboardingSeen: onboardingSeen,
    savedThemeMode: savedThemeMode,
  ));
}

class MyApp extends StatelessWidget {
  final bool onboardingSeen;
  final String? savedThemeMode;

  const MyApp({super.key, required this.onboardingSeen, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData().textTheme);

    // Determinar el themeMode basado en el valor guardado
    ThemeMode themeMode;
    if (savedThemeMode == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode
          .system; // Si no hay tema guardado, usar el predeterminado del sistema
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: onboardingSeen ? AppRoutes.main : AppRoutes.onboarding,
      getPages: AppRoutes.routes,
      themeMode:
          themeMode, // Usar el tema guardado o predeterminado del sistema

      // 🌞 Tema Claro
      theme: materialTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'SFProDisplay',
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
                  fontFamily: 'SFProDisplay',
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
