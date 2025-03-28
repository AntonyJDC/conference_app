import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/get_event_by_id_use_case.dart';
import 'package:conference_app/ui/pages/event/widgets/event_image.dart';
import 'package:conference_app/ui/pages/event/widgets/event_info.dart';
import 'package:conference_app/ui/pages/event/widgets/subscribe_button.dart';
import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  late Rx<EventModel> event;
  late FavoriteController favoriteController;

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
    }
  }

  @override
  Widget build(BuildContext context) {
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
                EventInfo(event: event),
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
                  () => favoriteController.toggleFavorite(event.value),
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                );
              }),
            ),
            SubscribeButton(event: event),
          ],
        ),
      );
    });
  }

  Widget _circleButton(VoidCallback onTap, IconData icon,
      {Color color = Colors.white}) {
    return GestureDetector(
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
