import 'package:conference_app/controllers/booked_events.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/local/events_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeButton extends StatelessWidget {
  final Rx<EventModel> event;
  const SubscribeButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final bookedEvtController = Get.find<BookedEventsController>();
    final theme = Theme.of(context).colorScheme;

    return Obx(() {
      final eventValue = event.value;

      // Validación: ¿El evento ya pasó?
      final eventDate = DateTime.tryParse(eventValue.date);
      final now = DateTime.now();
      final isPastEvent = eventDate != null && eventDate.isBefore(now);

      // Verificar si ya está suscrito
      final bool isSubscribed =
          bookedEvtController.tasks.any((e) => e.id == eventValue.id);

      String buttonText;
      Color buttonColor;
      VoidCallback? onPressed;

      if (isPastEvent) {
        buttonText = "Evento finalizado";
        buttonColor = Colors.grey;
        onPressed = null;
      } else if (isSubscribed) {
        buttonText = "Ya estás suscrito";
        buttonColor = Colors.grey;
        onPressed = null;
      } else if (eventValue.spotsLeft > 0) {
        buttonText = "Suscribirme";
        buttonColor = theme.primary;
        onPressed = () {
          // Agregar evento a la lista de suscritos
          bookedEvtController.addTask(eventValue);

          // Restar 1 a los cupos disponibles
          event.update((e) {
            if (e != null) e.spotsLeft = (e.spotsLeft - 1).clamp(0, e.capacity);
          });

          // También actualizar la lista dummyEvents
          int index = dummyEvents.indexWhere((e) => e.id == eventValue.id);
          if (index != -1) {
            dummyEvents[index] = eventValue;
          }
        
          // Mostrar confirmación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Te has suscrito al evento')),
          );
        };
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
    });
  }
}