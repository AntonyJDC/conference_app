import 'package:conference_app/controllers/booked_events.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeButton extends StatelessWidget {
  final EventModel event;
  const SubscribeButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final bookedEvtController = Get.find<BookedEventsController>();
    final theme = Theme.of(context).colorScheme;

    // Validación: ¿El evento ya pasó?
    final eventDate = DateTime.tryParse(event.date);
    final now = DateTime.now();
    final isPastEvent = eventDate != null && eventDate.isBefore(now);

    String buttonText;
    Color buttonColor;
    VoidCallback? onPressed;

    // Lógica de condiciones
    if (isPastEvent) {
      buttonText = "Evento finalizado";
      buttonColor = Colors.grey;
      onPressed = null;
    } else if (event.spotsLeft > 0) {
      if (bookedEvtController.isEventInTasks(
          event.id, bookedEvtController.tasks)) {
        buttonText = "Suscrito";
        buttonColor = Colors.grey;
        onPressed = null;
      } else {
        buttonText = "Suscribirme";
        buttonColor = theme.primary;
        onPressed = () {
          // Acción de suscripción
          bookedEvtController.addTask(
            BookedEventsController.convertEventsToTasks([event]).first,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Te has suscrito al evento')),
          );
          Get.offAllNamed(AppRoutes.home);
        };
      }
    } else {
      buttonText = "Agotado";
      buttonColor = Colors.grey;
      onPressed = null;
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: theme.surface),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
