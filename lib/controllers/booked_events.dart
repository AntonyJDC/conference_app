import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class BookedEventsController extends GetxController {
  final _tasks = <TimePlannerTask>[
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
}
