import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';

class SubscribeButton extends StatelessWidget {
  final EventModel event;
  const SubscribeButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: event.spotsLeft > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: event.spotsLeft > 0 ? () {} : null,
            child: Text(event.spotsLeft > 0 ? "Suscribirme" : "Agotado",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
