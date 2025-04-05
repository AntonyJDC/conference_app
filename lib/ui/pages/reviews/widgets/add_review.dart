import 'dart:ui';
import 'package:conference_app/domain/use_case/reviews/add_review_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/update_average_rating_use_case.dart';
import 'package:conference_app/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:conference_app/domain/use_case/reviews/has_reviewed_use_case.dart';

class AddReviewPage extends StatefulWidget {
  final String eventId;

  const AddReviewPage({super.key, required this.eventId});

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<AddReviewPage> {
  double rating = 0.0;
  TextEditingController commentController = TextEditingController();
  RxBool hasReviewed = false.obs;

  @override
  void initState() {
    super.initState();
    _checkIfReviewed();
  }

  Future<void> _checkIfReviewed() async {
    bool reviewed = await HasReviewedUseCase().execute(widget.eventId);
    hasReviewed.value = reviewed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            centerTitle: true,
            expandedHeight: 100,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsedHeight =
                    64.0 + MediaQuery.of(context).padding.top;
                final bool isCollapsed =
                    constraints.maxHeight <= collapsedHeight;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isCollapsed)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                          child: Container(
                            color: theme.colorScheme.surface.withOpacity(0.1),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: isCollapsed ? 0 : 16,
                        bottom: 10,
                      ),
                      child: Align(
                        alignment: isCollapsed
                            ? Alignment.bottomCenter
                            : Alignment.bottomLeft,
                        child: Text(
                          'Califica el evento',
                          style: TextStyle(
                            fontSize: isCollapsed ? 16 : 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
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
                            setState(() {
                              rating = newRating;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Comentarios:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
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
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancelar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final review = ReviewModel(
                                eventId: widget.eventId,
                                rating: rating.toInt(),
                                comment: commentController.text,
                                createdAt: DateTime.now().toIso8601String(),
                              );

                              await AddReviewUseCase().execute(review);
                              await UpdateAverageRatingUseCase()
                                  .execute(widget.eventId);

                              hasReviewed.value = true;

                              Navigator.pop(context); // Cerrar la página
                            },
                            child: Text("Guardar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
