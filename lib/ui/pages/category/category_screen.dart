import 'dart:ui';

import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:conference_app/domain/use_case/events/get_events_by_category_use_case.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = Get.arguments as String;
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<List<EventModel>>(
        future: GetEventsByCategoryUseCase().execute(category),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
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
                              filter:
                                  ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                              child: Container(
                                color: theme.colorScheme.surface
                                    .withValues(alpha: 0.1),
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
                              category,
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
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (snapshot.connectionState == ConnectionState.done &&
                  (!snapshot.hasData || snapshot.data!.isEmpty))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_busy,
                              size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No hay eventos en esta categoría'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (snapshot.hasData && snapshot.data!.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: EventCard(event: event),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
