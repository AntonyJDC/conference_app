import 'dart:ui';

import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/booking/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final BookedEventsController bookedEventsController;
  late Map<DateTime, List<EventModel>> _events;
  late List<EventModel> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late Worker _taskListener;

  @override
  void initState() {
    super.initState();
    bookedEventsController = Get.find<BookedEventsController>();
    _events = {};
    _selectedEvents = [];
    _selectedDay = _focusedDay;

    _taskListener = ever(bookedEventsController.tasks, (_) {
      if (mounted) {
        _loadEvents();
      }
    });

    _loadEvents();
  }

  @override
  void dispose() {
    _taskListener.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _loadEvents() async {
    final Map<DateTime, List<EventModel>> newEvents = {};

    for (var event in bookedEventsController.tasks) {
      final eventDate = _normalizeDate(DateTime.parse(event.date));
      newEvents.putIfAbsent(eventDate, () => []).add(event);
    }

    if (mounted) {
      setState(() {
        _events = newEvents;
        _selectedEvents = _getEventsForDay(_selectedDay!);
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _events[normalizedDay] ?? [];
  }

  DateTime? _getNearestEventDate() {
    if (bookedEventsController.tasks.isEmpty) return null;

    final now = DateTime.now();

    final sortedEvents = List.from(bookedEventsController.tasks)
      ..sort((a, b) {
        final dateA = DateTime.parse(a.date);
        final dateB = DateTime.parse(b.date);
        return dateA
            .difference(now)
            .inSeconds
            .abs()
            .compareTo(dateB.difference(now).inSeconds.abs());
      });

    return DateTime.parse(sortedEvents.first.date);
  }

  void _goToNearestEvent() {
    final nearestDate = _getNearestEventDate();
    if (nearestDate != null && mounted) {
      setState(() {
        _focusedDay = nearestDate;
        _selectedDay = nearestDate;
        _selectedEvents = _getEventsForDay(nearestDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasEvents = bookedEventsController.tasks.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final daysOfWeekHeight = screenWidth < 400 ? 50 : 70;

    return Scaffold(
      body: CustomScrollView(
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
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
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
                          "Mis eventos",
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

          // 📅 Calendario y eventos
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    locale: 'es_CO',
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 3,
                    ),
                    daysOfWeekHeight: daysOfWeekHeight.toDouble(),
                    headerStyle: HeaderStyle(
                      headerPadding: const EdgeInsets.only(top: 10),
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      formatButtonVisible: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                      weekendStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: _getEventsForDay,
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return const SizedBox();
                        final brightness = theme.brightness;
                        final color = brightness == Brightness.dark
                            ? Colors.white
                            : theme.colorScheme.inversePrimary;

                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              events.length.clamp(1, 3),
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _selectedEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('No tienes eventos para hoy'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = _selectedEvents[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: EventCard(event: event),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: hasEvents
          ? FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              onPressed: _goToNearestEvent,
              child: Icon(Icons.arrow_upward_rounded,
                  color: theme.colorScheme.onPrimary),
            )
          : null,
    );
  }
}
