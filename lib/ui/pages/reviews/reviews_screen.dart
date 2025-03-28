import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool showFeedbacks = true;
  final controller = Get.find<BookedEventsController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              color: colorScheme.primary,
              child: Center(
                child: Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: colorScheme.outline.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showFeedbacks = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: showFeedbacks
                                ? colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Feedbacks',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: showFeedbacks
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showFeedbacks = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !showFeedbacks
                                ? colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Eventos finalizados',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !showFeedbacks
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final now = DateTime.now();
                final events = controller.tasks;

                final feedbackEvents = events
                    .where((e) => e.comment != null || e.rating != null)
                    .toList();

                final completedEvents = events.where((e) {
                  final eventDate = DateTime.tryParse(e.date);
                  return eventDate != null && eventDate.isBefore(now);
                }).toList();

                final displayed =
                    showFeedbacks ? feedbackEvents : completedEvents;

                if (displayed.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay eventos aún.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: displayed.length,
                  itemBuilder: (context, index) {
                    final event = displayed[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventCard(event: event),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 12),
                          child: showFeedbacks
                              ? Text(
                                  '⭐ ${event.rating ?? '-'} — ${event.comment ?? 'Sin comentario'}',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                )
                              : Text(
                                  event.comment != null || event.rating != null
                                      ? '✅ Ya dejaste feedback.'
                                      : '❗ No dejaste feedback.',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: event.comment == null &&
                                            event.rating == null
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                        )
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
