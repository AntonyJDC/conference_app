import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final String review;
  final String date;
  final int rating;

  const ReviewCard({
    super.key,
    required this.review,
    required this.date,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Usuario + Fecha
          Row(
            children: [
              const Icon(Icons.person, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Anónimo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Spacer(),
              Text(
                DateFormat("d 'de' MMMM 'de' y", 'es_CO')
                    .format(DateTime.parse(date)),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Estrellas según el rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                size: 14,
                color: Colors.amber,
              );
            }),
          ),

          const SizedBox(height: 8),

          /// Comentario
          Text(
            review,
            style: const TextStyle(fontSize: 12),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
