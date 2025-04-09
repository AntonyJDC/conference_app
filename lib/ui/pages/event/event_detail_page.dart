import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/get_event_by_id_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/get_reviews_by_event_use_case.dart';
import 'package:conference_app/ui/pages/event/widgets/animated_favorite.dart';
import 'package:conference_app/ui/pages/event/widgets/explosion_animation.dart';
import 'package:conference_app/ui/pages/event/widgets/event_image.dart';
import 'package:conference_app/ui/pages/event/widgets/event_info.dart';
import 'package:conference_app/ui/pages/event/widgets/subscribe_button.dart';
import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/ui/pages/reviews/widgets/see_all_reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  late Rx<EventModel> event;
  late FavoriteController favoriteController;
  bool _showHeartAnimation = false;
  bool _showExplosionAnimation = false;
  Offset _favButtonPosition = Offset.zero;
  int? totalReviewsCount;

  @override
  void initState() {
    super.initState();
    favoriteController = Get.find<FavoriteController>();

    final initialEvent = Get.arguments as EventModel;
    event = initialEvent.obs;

    _loadEventFromDb(initialEvent.id);
  }

  Future<void> _loadEventFromDb(String id) async {
    final eventFromDb = await GetEventByIdUseCase().execute(id);
    if (eventFromDb != null) {
      event.value = eventFromDb;

      // ✅ Obtener cantidad de reseñas
      final reviews = await GetReviewsByEventUseCase().execute(id);
      setState(() {
        totalReviewsCount = reviews.length;
      });
    }
  }

  void _toggleFavorite(GlobalKey favButtonKey) {
    final RenderBox renderBox =
        favButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _favButtonPosition = position;
      if (favoriteController.isFavorite(event.value)) {
        _showExplosionAnimation = true;
      } else {
        _showHeartAnimation = true;
      }
    });

    favoriteController.toggleFavorite(event.value);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey favButtonKey = GlobalKey();

    return Obx(() {
      final eventData = event.value;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                EventImage(event: eventData),
                EventInfo(
                  event: event,
                  onTap: () {
                    Get.to(() => EventAllReviewsPage(event: event.value));
                  },
                  totalReviews: totalReviewsCount,
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 16,
              child: _circleButton(() => Get.back(), Icons.arrow_back),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Obx(() {
                bool isFav = favoriteController.isFavorite(event.value);
                return _circleButton(
                  () => _toggleFavorite(favButtonKey),
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                  key: favButtonKey,
                );
              }),
            ),
            SubscribeButton(event: event),
            if (_showHeartAnimation)
              FavoriteAnimationWidget(
                targetPosition: _favButtonPosition,
                onComplete: () {
                  setState(() => _showHeartAnimation = false);
                },
              ),
            if (_showExplosionAnimation)
              ExplosionAnimationWidget(
                targetPosition: _favButtonPosition,
                onComplete: () {
                  setState(() => _showExplosionAnimation = false);
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _circleButton(VoidCallback onTap, IconData icon,
      {Color color = Colors.white, Key? key}) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
