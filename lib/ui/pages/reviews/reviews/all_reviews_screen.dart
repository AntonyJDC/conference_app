import 'package:flutter/material.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:get/get.dart';
import 'package:conference_app/domain/use_case/booked_events_use_case.dart';

class AllReviewsScreen extends StatefulWidget {
  final EventModel event;

  const AllReviewsScreen({super.key, required this.event});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  final commentController = TextEditingController();
  double rating = 0;

  final fakeReviews = [
    {"rating": 5.0, "comment": "Excelente organización y ambiente"},
    {"rating": 4.0, "comment": "Muy divertido pero faltó música"},
    {"rating": 3.0, "comment": "Estuvo bien, pero no fue espectacular"},
    {"rating": 4.5, "comment": "Muy buena experiencia, repetiría"},
    {"rating": 2.5, "comment": "Demasiado ruido, no me gustó"},
    {"rating": 5.0, "comment": "Perfecto en todo sentido"},
    {"rating": 4.0, "comment": "Buena logística y ambiente"},
    {"rating": 3.5, "comment": "No fue lo que esperaba, pero bien"},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas del evento'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: fakeReviews.length,
                itemBuilder: (context, index) {
                  final review = fakeReviews[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.grey),
                              const SizedBox(width: 8),
                              const Text('Anónimo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              const Spacer(),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    Icons.star,
                                    size: 14,
                                    color:
                                        i < (review['rating'] as double).round()
                                            ? Colors.amber
                                            : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review['comment'] as String,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 30),
            Text(
              'Deja tu reseña',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final comment = commentController.text.trim();
                if (comment.isNotEmpty && rating > 0) {
                  final controller = Get.find<BookedEventsController>();
                  final index = controller.tasks
                      .indexWhere((e) => e.id == widget.event.id);
                  if (index != -1) {
                    final updated = controller.tasks[index].copyWith(
                      comment: comment,
                      rating: rating,
                    );
                    controller.updateEvent(updated); // 🌀 actualiza la UI
                    await BookedEventsUseCase()
                        .updateEvent(updated); // 💾 guarda en BD
                  }

                  Get.back(); // volver al historial
                  Get.snackbar('Gracias', 'Tu reseña ha sido enviada');
                } else {
                  Get.snackbar(
                      'Error', 'Debes dejar un comentario y calificación');
                }
              },
              icon: const Icon(Icons.send),
              label: const Text('Enviar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
