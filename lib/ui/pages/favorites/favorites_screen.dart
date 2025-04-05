import 'dart:ui';
import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        final favorites = favoriteController.favorites;

        return CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.primary,
              centerTitle: true,
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
                            filter:
                                ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
                            child: Container(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                      // Título
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
                            "Favoritos",
                            style: TextStyle(
                              fontSize: isCollapsed ? 14 : 22,
                              fontWeight: FontWeight.w600,
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

            // Lista de eventos favoritos o mensaje vacío
            if (favorites.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.favorite_border,
                            size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('No tienes eventos favoritos'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = favorites[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      child: EventCard(
                        event: event,
                        showDate: true,
                        showFavorite: true,
                      ),
                    );
                  },
                  childCount: favorites.length,
                ),
              ),
          ],
        );
      }),
    );
  }
}
