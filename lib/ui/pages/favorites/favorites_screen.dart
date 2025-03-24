import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/ui/widgets/second_event_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No tienes eventos favoritos'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final event = favorites[index];
            return SecondEventCard(event: event);
          },
        );
      }),
    );
  }
}
