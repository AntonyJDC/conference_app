import 'dart:ui';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<EventModel> events;

  const EventListPage({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            centerTitle: true,
            expandedHeight: 100,
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
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
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
                          title,
                          style: TextStyle(
                            fontSize: isCollapsed ? 16 : 22,
                            fontWeight: FontWeight.bold,
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
          // Content below the AppBar
          events.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_busy,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(emptyMessage),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: EventCard(
                          event: event,
                          showFavorite: false,
                          showDate: true,
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
        ],
      ),
    );
  }
}
