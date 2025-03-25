import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/booked_events.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
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
    _taskListener.dispose(); // Cancela la escucha al destruir el widget
    super.dispose();
  }

  void _loadEvents() {
    final Map<DateTime, List<EventModel>> newEvents = {};

    for (var event in bookedEventsController.tasks) {
      DateTime eventDate = DateTime.parse(event.date);
      newEvents.putIfAbsent(eventDate, () => []).add(event);
    }

    if (mounted) {
      setState(() {
        _events = newEvents;
        _selectedEvents = _events[_selectedDay] ?? [];
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
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  DateTime? _getNearestEventDate() {
    if (bookedEventsController.tasks.isEmpty) return null;

    DateTime now = DateTime.now();
    List<EventModel> sortedEvents = List.from(bookedEventsController.tasks)
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a.date);
        DateTime dateB = DateTime.parse(b.date);
        return dateA
            .difference(now)
            .inSeconds
            .abs()
            .compareTo(dateB.difference(now).inSeconds.abs());
      });

    return DateTime.parse(sortedEvents.first.date);
  }

  void _goToNearestEvent() {
    DateTime? nearestDate = _getNearestEventDate();
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
    bool hasEvents = bookedEventsController.tasks.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booked Events',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.99),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) => _events[day] ?? [],
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
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(child: Text("No events for this day"))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _selectedEvents[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(event.imageUrl),
                          title: Text(event.title),
                          subtitle: Text(
                              "${event.startTime} - ${event.endTime} at ${event.location}"),
                          onTap: () => Get.toNamed('/detail', arguments: event),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: hasEvents
          ? FloatingActionButton(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.99),
              onPressed: _goToNearestEvent,
              child: const Icon(Icons.forward),
            )
          : null,
    );
  }
}
