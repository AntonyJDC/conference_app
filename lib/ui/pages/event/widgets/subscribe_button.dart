import 'dart:async';
import 'dart:io';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/controllers/review_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/update_event_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/get_my_reviews_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'animated_dialog.dart';
import 'package:http/http.dart' as http;

Future<bool> hasRealConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

final String baseUrl = dotenv.env['API_BASE_URL']!;

Future<void> subscribeToEvent(String id) async {
  final url = Uri.parse('$baseUrl/events/$id/subscribe');
  final res = await http.post(url);
  if (res.statusCode != 200) {
    throw Exception('Error al suscribirse al evento');
  }
}

Future<void> unsubscribeFromEvent(String id) async {
  final url = Uri.parse('$baseUrl/events/$id/unsubscribe');
  final res = await http.post(url);
  if (res.statusCode != 200) {
    throw Exception('Error al cancelar la suscripción al evento');
  }
}

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
          final connected = await hasRealConnection();
          if (!connected) {
            showAnimatedDialog(
              context,
              'No tienes conexión a Internet',
              isCheck: false,
            );
            return;
          }

          try {
            await unsubscribeFromEvent(eventValue.id);

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
          } catch (e) {
            showAnimatedDialog(
              context,
              'Hubo un error al cancelar tu suscripción',
              isCheck: false,
            );
          }
        };
      } else if (eventValue.spotsLeft > 0) {
        buttonText = "Suscribirse";
        buttonColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        onPressed = () async {
          final connected = await hasRealConnection();
          if (!connected) {
            showAnimatedDialog(
              context,
              'No tienes conexión a Internet',
              isCheck: false,
            );
            return;
          }

          try {
            // 🔁 POST al backend
            await subscribeToEvent(eventValue.id);

            // 🗂 Guardar en historial local
            bookedEvtController.addTask(eventValue);

            // ✅ Cargar solo la review del usuario (si existe)
            final myReviews = await GetMyReviewsUseCase().execute();
            final myReview =
                myReviews.firstWhereOrNull((r) => r.eventId == eventValue.id);

            if (myReview != null) {
              final reviewController = Get.find<ReviewController>();
              await reviewController.addReview(myReview);
            }

            // 🟢 Reducir cupo
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
          } catch (e) {
            showAnimatedDialog(
              context,
              'Hubo un error al suscribirte',
              isCheck: false,
            );
          }
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
