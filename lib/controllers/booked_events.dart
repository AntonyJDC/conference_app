import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/theme/rand_color.dart';

class BookedEventsController extends GetxController {
  final tasks = convertEventsToTasks([]).obs;

  void addTask(TimePlannerTask newTask) {
    tasks.add(newTask);
  }

  static List<TimePlannerTask> convertEventsToTasks(List<EventModel> events) {
    return events.map((event) {
      final startParts = event.startTime.split(':');
      final endParts = event.endTime.split(':');
      final id = event.id;
      final startHour = int.parse(startParts[0]);
      final startMinutes = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinutes = int.parse(endParts[1]);

      final durationMinutes =
          ((endHour * 60 + endMinutes) - (startHour * 60 + startMinutes)).abs();

      return TimePlannerTask(
        key: Key(id),
        color: ColorR.getBrightRandomColor(),
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

  bool isEventInTasks(String eventId, RxList<TimePlannerTask> tasks) {
    return tasks.any((task) => task.key == Key(eventId));
  }

  static TimePlannerTask? findNearestEvent(List<TimePlannerTask> tasks) {
    if (tasks.isEmpty) return null;

    DateTime now = DateTime.now();
    return tasks.reduce((nearest, current) {
      DateTime nearestDate = now.add(Duration(days: nearest.dateTime.day));
      DateTime currentDate = now.add(Duration(days: current.dateTime.day));

      return currentDate.isBefore(nearestDate) ? current : nearest;
    });
  }

  static DateTime? findNearestEventDate(List<TimePlannerTask> tasks) {
    TimePlannerTask? nearestTask = findNearestEvent(tasks);
    return nearestTask != null
        ? DateTime.now().add(Duration(days: nearestTask.dateTime.day))
        : null;
  }
}
