import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String review;
  final String date;

  const ReviewCard({super.key, required this.review, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ Título
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    date,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ⭐ Reseña
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
