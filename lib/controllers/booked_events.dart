import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'package:conference_app/data/models/event_model.dart';

class BookedEventsController extends GetxController {
  final _tasks = <TimePlannerTask>[
    //Reemplazar con la lista de eventos a los que se suscriba el usuario (deben venir de EventDetailPage)
    TimePlannerTask(
      color: Colors.purple,
      dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 30),
      minutesDuration: 90,
      daysDuration: 1,
      onTap: () {},
      child: Text(
        'Meeting with team',
        style: TextStyle(color: Colors.grey[350], fontSize: 12),
      ),
    ),
    TimePlannerTask(
      color: Colors.blue,
      dateTime: TimePlannerDateTime(day: 1, hour: 10, minutes: 0),
      minutesDuration: 60,
      daysDuration: 1,
      onTap: () {},
      child: Text(
        'Client presentation',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
    TimePlannerTask(
      color: Colors.green,
      dateTime: TimePlannerDateTime(day: 2, hour: 16, minutes: 15),
      minutesDuration: 45,
      daysDuration: 1,
      onTap: () {},
      child: Text(
        'Cooking class',
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
    ),
  ].obs;

  List<TimePlannerTask> get getTask => _tasks;

  void addTasks(List<TimePlannerTask> newTasks) {
    _tasks.addAll(newTasks);
  }

  List<TimePlannerTask> convertEventsToTasks(List<EventModel> events) {
    return events.map((event) {
      final startParts = event.startTime.split(':');
      final endParts = event.endTime.split(':');

      final startHour = int.parse(startParts[0]);
      final startMinutes = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinutes = int.parse(endParts[1]);

      final durationMinutes =
          ((endHour * 60 + endMinutes) - (startHour * 60 + startMinutes)).abs();

      return TimePlannerTask(
        color: Colors.purple,
        dateTime:
            TimePlannerDateTime(day: 0, hour: startHour, minutes: startMinutes),
        minutesDuration: durationMinutes,
        daysDuration: 1,
        onTap: () {
          // Puedes manejar la interacción con el evento aquí
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              event.location,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
}
