import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/widgets/build_image.dart';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final EventModel event;
  const EventImage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.35;

    return Stack(
      children: [
        buildImage(
          event,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
