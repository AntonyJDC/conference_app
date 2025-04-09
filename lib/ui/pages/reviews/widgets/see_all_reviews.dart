import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/domain/use_case/reviews/get_reviews_by_event_use_case.dart';
import 'package:conference_app/ui/pages/reviews/widgets/reviews_card.dart';
import 'package:conference_app/ui/widgets/event_rating_stars.dart';
import 'package:flutter/material.dart';

class EventAllReviewsPage extends StatefulWidget {
  final EventModel event;

  const EventAllReviewsPage({super.key, required this.event});

  @override
  State<EventAllReviewsPage> createState() => _EventAllReviewsPageState();
}

class _EventAllReviewsPageState extends State<EventAllReviewsPage> {
  List<ReviewModel> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final data = await GetReviewsByEventUseCase().execute(widget.event.id);
    setState(() {
      reviews = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas las reseñas"),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reviews.isEmpty
              ? const Center(
                  child: Text("Este evento aún no tiene reseñas."),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado con rating promedio
                      Row(
                        children: [
                          Text(
                            widget.event.averageRating?.toStringAsFixed(1) ??
                                "0.0",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EventRatingStars(
                                event: widget.event,
                                average: widget.event.averageRating ?? 0.0,
                                showReviewCount: false,
                                iconSize: 20,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${reviews.length} ${reviews.length == 1 ? "opinión" : "opiniones"}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Lista de reviews
                      Expanded(
                        child: ListView.separated(
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return ReviewCard(
                              review: review.comment,
                              date: review.createdAt.split('T').first,
                              rating: review.rating,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
