import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/event_image.dart';
import 'widgets/event_info.dart';
import 'widgets/subscribe_button.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    late EventModel event;
    try {
      event = Get.arguments as EventModel;
    } catch (e) {
      return const Scaffold(
          body: Center(child: Text('Error al cargar el evento.')));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              EventImage(event: event),
              EventInfo(event: event),
            ],
          ),
          SubscribeButton(event: event),
        ],
      ),
    );
  }
}
