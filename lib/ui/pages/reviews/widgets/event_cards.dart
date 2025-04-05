import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/check_event_status_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/add_review_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/get_review_for_event_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/update_average_rating_use_case.dart';
import 'package:conference_app/ui/widgets/event_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:conference_app/data/models/review_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EventCardReviews extends StatefulWidget {
  final EventModel event;
  final bool showFavorite, showDate, showRating;
  final double? rating;

  const EventCardReviews({
    super.key,
    required this.event,
    this.showFavorite = false,
    this.showDate = false,
    this.showRating = false,
    this.rating,
  });

  @override
  EventCardState createState() => EventCardState();
}

class EventCardState extends State<EventCardReviews> {
  // Estado reactivo para controlar si ya se hizo una reseña
  RxBool hasReviewed =
      false.obs; // RxBool para que cambie la estrella inmediatamente

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.parse(widget.event.date);
    final isPastEvent = CheckEventStatusUseCase().execute(widget.event);
    final favoriteController = Get.find<FavoriteController>();

    final banderinColor =
        isPastEvent ? theme.colorScheme.errorContainer : Colors.green;

    final banderinTextColor = isPastEvent
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              widget.event.imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          if (widget.showDate)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                width: 44,
                height: 54,
                decoration: BoxDecoration(
                  color: banderinColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                          color: banderinTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM', 'es_CO').format(date).toUpperCase(),
                      style: TextStyle(
                          color: banderinTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.showFavorite)
            Positioned(
              top: 12,
              right: 12,
              child: Obx(() {
                final isFavorite = favoriteController.isFavorite(widget.event);
                return GestureDetector(
                  onTap: () => favoriteController.toggleFavorite(widget.event),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? const Color.fromARGB(255, 255, 17, 0)
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                );
              }),
            ),
          // Mostrar estrella si `showRating` es verdadero
          if (widget.showRating)
            Positioned(
              top: 12,
              right: 12,
              child: Obx(() {
                // Usamos el estado reactivo `hasReviewed`
                final reviewed = hasReviewed.value;

                return GestureDetector(
                  onTap: () async {
                    if (!reviewed && context.mounted) {
                      _showReviewDialog(context, widget.event.id);
                    } else {
                      _showReview(context, widget.event.id);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      reviewed ? Icons.star : Icons.star_border,
                      color: reviewed ? Colors.green : Colors.white,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),

          Positioned(
            bottom: -30,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.event.location,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.timer,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: isPastEvent
                                  ? const Text(
                                      'Evento finalizado',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    )
                                  : Text(
                                      '${widget.event.startTime} - ${widget.event.endTime}',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          Get.toNamed('/detail', arguments: widget.event),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cuadro de diálogo para dejar la reseña
  void _showReviewDialog(BuildContext context, String eventId) {
    double rating = 0;
    TextEditingController commentController = TextEditingController();

    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Título
                  Center(
                    child: Text(
                      "¿Cómo calificarías este evento?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // RatingBar centrada
                  Center(
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      itemSize: 40,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.green,
                      ),
                      onRatingUpdate: (newRating) {
                        rating = newRating; // Actualiza la calificación
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Comentarios:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  // Área de comentarios
                  TextField(
                    cursorColor: Theme.of(context).colorScheme.primary,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    controller: commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.outlineVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  // Botones de cancelar y guardar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar el modal
                        },
                        child: Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Color verde
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Bordes redondeados
                          ),
                        ),
                        onPressed: () async {
                          final review = ReviewModel(
                            eventId: eventId,
                            rating: rating.toInt(),
                            comment: commentController.text,
                            createdAt: DateTime.now().toIso8601String(),
                          );

                          await AddReviewUseCase().execute(review);
                          await UpdateAverageRatingUseCase().execute(eventId);

                          // Actualizamos el estado reactivo después de guardar la reseña
                          hasReviewed.value = true;

                          Navigator.pop(context); // Cerrar el modal
                        },
                        child: Text("Guardar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showReview(BuildContext context, String eventId) {
    TextEditingController commentController = TextEditingController();
    double rating = 0;

    // Ejecutar el use case para obtener la reseña
    GetReviewForEventUseCase().execute(eventId).then((review) {
      if (review != null) {
        // Si existe una reseña, mostramos la calificación y el comentario
        rating = review.rating.toDouble();
        commentController.text = review.comment;
      }

      showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(
                  FocusNode()); // Dismiss keyboard when tapping outside
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ajusta el tamaño del modal según el contenido
                  children: [
                    // Línea superior para indicar deslizar
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Título
                    Center(
                      child: Text(
                        "Tu reseña de este evento",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // RatingBar con la calificación existente
                    Center(
                      child: EventRatingStars(
                          event: widget.event,
                          average: rating,
                          iconSize: 40,
                          showReviewCount: false,
                          mainAxisAlignment: MainAxisAlignment.center),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "Tus comentarios:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    // Área de comentarios (solo lectura)
                    TextField(
                      controller: commentController,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.outlineVariant,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      maxLines: 4,
                      readOnly: true, // El TextField es solo lectura
                    ),
                    const SizedBox(height: 16),
                    // Botón para cerrar el modal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el modal
                          },
                          child: Text("Cerrar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// Cuadro de diálogo para dejar la reseña
