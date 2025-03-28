import 'dart:async';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/can_subscribe_to_event_use_case.dart';
import 'package:conference_app/domain/use_case/check_event_status_use_case.dart';
import 'package:conference_app/domain/use_case/update_event_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;

class SubscribeButton extends StatefulWidget {
  final Rx<EventModel> event;
  const SubscribeButton({super.key, required this.event});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  late Timer _timer;
  late BookedEventsController bookedEvtController;
  late ColorScheme theme;

  @override
  void initState() {
    super.initState();
    bookedEvtController = Get.find<BookedEventsController>();
    tz.initializeTimeZones();

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
    theme = Theme.of(context).colorScheme;

    return Obx(() {
      final eventValue = widget.event.value;
      final isPastEvent = CheckEventStatusUseCase().execute(eventValue);
      final isSubscribed =
          bookedEvtController.tasks.any((e) => e.id == eventValue.id);

      String buttonText;
      Color buttonColor;
      VoidCallback? onPressed;

      if (isPastEvent) {
        buttonText = "Evento finalizado";
        buttonColor = Colors.grey;
        onPressed = null;
      } else if (isSubscribed) {
        buttonText = "Darse de baja";
        buttonColor = Colors.red;
        onPressed = () async {
          final updatedEvent = eventValue.copyWith(
            spotsLeft: (eventValue.spotsLeft + 1).clamp(0, eventValue.capacity),
          );
          await UpdateEventUseCase().execute(updatedEvent);

          bookedEvtController.removeTask(eventValue.id);

          widget.event.value = updatedEvent;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTopSnackBar(context, 'Cancelaste tu suscripción al evento');
          });
        };
      } else {
        buttonText = eventValue.spotsLeft > 0 ? "Suscribirse" : "Agotado";
        buttonColor = eventValue.spotsLeft > 0 ? theme.primary : Colors.grey;
        onPressed = eventValue.spotsLeft > 0
            ? () async {
                final canSubscribe =
                    await CanSubscribeToEventUseCase().execute(eventValue);

                if (!canSubscribe) {
                  showTopSnackBar(
                      context, 'No puedes suscribirte a este evento');
                  return;
                }

                // 🔄 Reducir cupos y actualizar en DB principal
                final updatedEvent = eventValue.copyWith(
                  spotsLeft:
                      (eventValue.spotsLeft - 1).clamp(0, eventValue.capacity),
                );
                await UpdateEventUseCase().execute(updatedEvent);

                await bookedEvtController.addTask(eventValue);

                widget.event.value = updatedEvent;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showTopSnackBar(context, 'Te has suscrito al evento');
                });
              }
            : null;
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

  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
