import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final controller = Get.find<BookedEventsController>();
  String selectedSegment = 'feedbacks';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Historial',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<String>(
                  backgroundColor: Colors.transparent,
                  thumbColor: colorScheme.primary,
                  groupValue: selectedSegment,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() => selectedSegment = value);
                    }
                  },
                  children: {
                    'feedbacks': _buildSegment('Feedbacks',
                        selected: selectedSegment == 'feedbacks'),
                    'finalizados': _buildSegment('Eventos',
                        selected: selectedSegment == 'finalizados'),
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  selectedSegment == 'feedbacks'
                      ? 'Aquí van los feedbacks 📋'
                      : 'Aquí van los eventos finalizados ✅',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Widget helper para que cada segmento tenga mismo ancho y se centre
  Widget _buildSegment(String text, {required bool selected}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: selected
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}