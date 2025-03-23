import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_planner/time_planner.dart';
import 'package:intl/intl.dart'; // Import para formatear fechas
import 'package:conference_app/controllers/booked_events.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final BookedEventsController controller = Get.put(BookedEventsController());

  // Método para obtener los títulos dinámicos con la fecha actual
  List<TimePlannerTitle> getHeaders() {
  // Obtener el evento más cercano
  TimePlannerTask? nearestTask = BookedEventsController.findNearestEvent(controller.getTask);
  DateTime baseDate = nearestTask != null
      ? DateTime.now().add(Duration(days: nearestTask.dateTime.day)) // Fecha del evento más cercano
      : DateTime.now(); // Fallback a la fecha actual si no hay eventos

  return List.generate(7, (index) {
    DateTime date = baseDate.add(Duration(days: index)); // Suma días desde la fecha base
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);
    String dayName = DateFormat('EEEE').format(date);
    return TimePlannerTitle(date: formattedDate, title: dayName);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Events'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TimePlanner(
          startHour: 6,
          endHour: 23,
          headers: getHeaders(), // Usa los encabezados dinámicos
          tasks: controller.getTask,
        ),
      ),
    );
  }
}