import 'dart:async';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/update_event_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'animated_dialog.dart';

class SubscribeButton extends StatefulWidget {
  final Rx<EventModel> event;
  const SubscribeButton({super.key, required this.event});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  late Timer _timer;
  late BookedEventsController bookedEvtController;
  late tz.Location _colombiaTZ;

  @override
  void initState() {
    super.initState();
    bookedEvtController = Get.find<BookedEventsController>();
    tz.initializeTimeZones();
    _colombiaTZ = tz.getLocation('America/Bogota');

    // ⏱ Actualiza cada 10 segundos
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final eventValue = widget.event.value;

      final eventDate = DateTime.tryParse(eventValue.date);
      final now = tz.TZDateTime.now(_colombiaTZ);
      bool isPastEvent = false;

      if (eventDate != null) {
        final endTimeParts = eventValue.endTime.split(':');
        final eventEnd = tz.TZDateTime(
          _colombiaTZ,
          eventDate.year,
          eventDate.month,
          eventDate.day,
          int.parse(endTimeParts[0]),
          int.parse(endTimeParts[1]),
        );
        isPastEvent =
            now.isAfter(eventEnd.subtract(const Duration(seconds: 2)));
      }

      final bool isSubscribed =
          bookedEvtController.tasks.any((e) => e.id == eventValue.id);

      String buttonText;
      Color buttonColor;
      Color textColor;
      VoidCallback? onPressed;

      if (isPastEvent) {
        buttonText = "Evento finalizado";
        buttonColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        onPressed = null;
      } else if (isSubscribed) {
        buttonText = "Darse de baja";
        buttonColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
        onPressed = () async {
          bookedEvtController.removeTask(eventValue.id);

          widget.event.value = widget.event.value.copyWith(
            spotsLeft: (widget.event.value.spotsLeft + 1)
                .clamp(0, widget.event.value.capacity),
          );

          await UpdateEventUseCase().execute(widget.event.value);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showAnimatedDialog(
              context,
              'Suscripción cancelada',
              isCheck: false,
            );
          });
        };
      } else if (eventValue.spotsLeft > 0) {
        buttonText = "Suscribirse";
        buttonColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        onPressed = () async {
          // ✅ Guardar en el historial (para feedbacks)
          bookedEvtController.addTask(eventValue);

          // 🟡 Reducir cupo
          widget.event.value = widget.event.value.copyWith(
            spotsLeft: (widget.event.value.spotsLeft - 1)
                .clamp(0, widget.event.value.capacity),
          );

          await UpdateEventUseCase().execute(widget.event.value);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showAnimatedDialog(
              context,
              'Te has suscrito al evento',
              isCheck: true,
            );
          });
        };
      } else {
        buttonText = "Agotado";
        buttonColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = colorScheme.onTertiaryContainer.withValues(alpha: 0.8);
        onPressed = null;
      }

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
