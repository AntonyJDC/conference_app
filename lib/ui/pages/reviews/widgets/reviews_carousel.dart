import 'package:conference_app/controllers/review_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/reviews/widgets/reviews_card.dart';
import 'package:conference_app/ui/widgets/event_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsCarousel extends StatefulWidget {
  final EventModel event;

  const ReviewsCarousel({super.key, required this.event});

  @override
  State<ReviewsCarousel> createState() => _ReviewsCarouselState();
}

class _ReviewsCarouselState extends State<ReviewsCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Get.find<ReviewController>().loadReviews(widget.event.id);
  }

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.find<ReviewController>();
    final theme = Theme.of(context).colorScheme;

    return Obx(() {
      final reviews = reviewController.getReviewsForEvent(widget.event.id);
      final double avg = widget.event.averageRating ?? 0.0;
      final int totalReviews = reviews.length;

      if (reviews.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventRatingStars(
                        event: widget.event,
                        average: avg,
                        showReviewCount: false,
                        iconSize: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalReviews ${totalReviews == 1 ? "opinión" : "opiniones"}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primary.withValues(alpha: 0.08),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primary.withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          Icons.star_border_rounded,
                          size: 24,
                          color: theme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Aún no hay opiniones sobre este evento",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sé el primero en calificarlo y ayuda a otros usuarios a interesarse en este evento.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventRatingStars(
                    event: widget.event,
                    average: avg,
                    showReviewCount: false,
                    iconSize: 18,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalReviews ${totalReviews == 1 ? "opinión" : "opiniones"}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _controller,
              itemCount: reviews.length.clamp(0, 5),
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ReviewCard(
                    review: review.comment,
                    date: review.createdAt.split("T").first,
                    rating: review.rating,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              reviews.length.clamp(0, 5),
              (index) => _buildDot(index),
            ),
          ),
        ],
      );
    });
  }

  AnimatedContainer _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 16 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
