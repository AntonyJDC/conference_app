import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Mis Favoritos',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final favorites = favoriteController.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('No tienes eventos favoritos')),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final event = favorites[index];
            final date = DateTime.parse(event.date);
            final day = DateFormat('dd').format(date);
            final month = DateFormat('MMM').format(date).toUpperCase();

            return InkWell(
              onTap: () => Get.toNamed('/detail', arguments: event),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              event.imageUrl,
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          event.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📌 Banderín de la fecha
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              month,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
