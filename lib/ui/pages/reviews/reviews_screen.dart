import 'dart:ui';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/ui/pages/reviews/widgets/event_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final controller = Get.find<BookedEventsController>();
  String selectedSegment = 'feedbacks';
  late final tz.Location _colombiaTZ;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _colombiaTZ = tz.getLocation('America/Bogota');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        final allBooked = controller.tasks;

        final finishedEvents = allBooked.where((event) {
          final eventDate = DateTime.parse(event.date);
          final endParts = event.endTime.split(':');

          final eventEnd = tz.TZDateTime(
            _colombiaTZ,
            eventDate.year,
            eventDate.month,
            eventDate.day,
            int.parse(endParts[0]),
            int.parse(endParts[1]),
          );

          return tz.TZDateTime.now(_colombiaTZ).isAfter(eventEnd);
        }).toList()
          ..sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

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
                              color: theme.colorScheme.surface.withOpacity(0.1),
                            ),
                          ),
                        ),
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
                            "Historial",
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<String>(
                          backgroundColor: Colors.transparent,
                          thumbColor: theme.colorScheme.primary,
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
                    if (selectedSegment == 'feedbacks')
                      const Text('Aquí van los feedbacks 📋',
                          style: TextStyle(fontSize: 16))
                    else if (finishedEvents.isEmpty)
                      const Text("No tienes eventos finalizados aún.",
                          style: TextStyle(fontSize: 16))
                    else
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Los eventos a los que has hecho feedback tendrán un ícono de estrella de color verde.",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          children: finishedEvents
                              .map((event) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: EventCardReviews(
                                      event: event,
                                      showDate: true,
                                      showFavorite: false,
                                      showRating: true,
                                    ),
                                  ))
                              .toList(),
                        )
                      ]),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSegment(String text, {required bool selected}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
