import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/theme_controller.dart';

class ThemeSelectorModal extends StatelessWidget {
  const ThemeSelectorModal({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final selected =
          themeController.selectedOption.value; // Estado del tema actual

      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Línea para indicar deslizar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Seleccionar tema",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Lista de opciones de tema
              RadioListTile<AppThemeMode>(
                value: AppThemeMode.system,
                groupValue: selected,
                onChanged: (value) {
                  themeController.selectedOption.value = value!;
                },
                title: const Text("Predeterminado del sistema"),
              ),
              RadioListTile<AppThemeMode>(
                value: AppThemeMode.dark,
                groupValue: selected,
                onChanged: (value) {
                  themeController.selectedOption.value = value!;
                },
                title: const Text("Oscuro"),
              ),
              RadioListTile<AppThemeMode>(
                value: AppThemeMode.light,
                groupValue: selected,
                onChanged: (value) {
                  themeController.selectedOption.value = value!;
                },
                title: const Text("Claro"),
              ),

              const SizedBox(height: 16),

              // Botones de "Cerrar" y "Guardar"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(context), // Cerrar sin cambios
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    ),
                    child: const Text("Cerrar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Guardar y aplicar el tema seleccionado
                      await themeController.saveTheme(selected);
                      Navigator.pop(context); // Cerrar después de guardar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    ),
                    child: const Text("Guardar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
