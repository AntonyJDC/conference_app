import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Música',
      'Tecnología',
      'Deportes',
      'Arte',
      'Moda',
      'Fiesta'
    ];
    final Map<String, IconData> categoryIcons = {
      'Música': Icons.music_note,
      'Tecnología': Icons.computer,
      'Deportes': Icons.sports_soccer,
      'Arte': Icons.color_lens,
      'Moda': Icons.checkroom,
      'Fiesta': Icons.wine_bar,
    };

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/category', arguments: category),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(categoryIcons[category] ?? Icons.category,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30),
                  ),
                ),
                const SizedBox(height: 6),
                Text(category, style: TextStyle(fontSize: 9)),
              ],
            ),
          );
        },
      ),
    );
  }
}
