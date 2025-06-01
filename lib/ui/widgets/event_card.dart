import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/check_event_status_use_case.dart';
import 'package:conference_app/ui/widgets/build_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  final bool showFavorite, showDate, showRating;

  const EventCard({
    super.key,
    required this.event,
    this.showFavorite = false,
    this.showDate = false,
    this.showRating = false,
  });

  @override
  EventCardState createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  bool isStarReviewed = false;

  void updateStarReview() {
    setState(() {
      isStarReviewed = true;
    });
  }

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
            child: buildImage(
              widget.event,
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
          Positioned(
            bottom: -30,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
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
}
