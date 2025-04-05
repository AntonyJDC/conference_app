import 'package:conference_app/controllers/review_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _PartialClipper extends CustomClipper<Rect> {
  final double fillPercent; // 0.0 a 1.0

  _PartialClipper(this.fillPercent);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fillPercent, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}

class EventRatingStars extends StatelessWidget {
  final EventModel event;
  final double? average; // puedes pasar un promedio si ya lo tienes (opcional)
  final bool showReviewCount;
  final Color? starColor;
  final Color? textColor;
  final double iconSize;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;

  const EventRatingStars({
    super.key,
    required this.event,
    this.average,
    this.showReviewCount = true,
    this.starColor,
    this.textColor,
    this.iconSize = 20,
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final reviewController = Get.find<ReviewController>();

    return Obx(() {
      final reviews = reviewController.getReviewsForEvent(event.id);
      final double avg = average ?? event.averageRating ?? 0.0;
      final int totalReviews = reviews.length;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          ...List.generate(5, (index) {
            final fullStarColor =
                avg == 0 ? Colors.grey : (starColor ?? Colors.amber);
            final fraction = avg - index;

            return Padding(
              padding: const EdgeInsets.only(
                  right: 4), // Cambia 4 por el espacio que quieras
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: Stack(
                  children: [
                    Icon(Icons.star, size: iconSize, color: Colors.grey),
                    if (fraction > 0)
                      ClipRect(
                        clipper: _PartialClipper(fraction.clamp(0.0, 1.0)),
                        child: Icon(Icons.star,
                            size: iconSize, color: fullStarColor),
                      ),
                  ],
                ),
              ),
            );
          }),
          if (showReviewCount) ...[
            SizedBox(width: spacing),
            Text(
              '$totalReviews ${totalReviews == 1 ? "opinión" : "opiniones"}',
              style: TextStyle(
                fontSize: iconSize * 0.6,
                color: textColor ??
                    (theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ]
        ],
      );
    });
  }
}
