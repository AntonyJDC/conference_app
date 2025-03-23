import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_planner/time_planner.dart';
import 'package:conference_app/controllers/booked_events.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final BookedEventsController controller = Get.put(BookedEventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incoming Events'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TimePlanner(
            startHour: 6,
            endHour: 23,
            headers: const [
              TimePlannerTitle(date: "3/10/2021", title: "Sunday"),
              TimePlannerTitle(date: "3/11/2021", title: "Monday"),
              TimePlannerTitle(date: "3/12/2021", title: "Tuesday"),
              TimePlannerTitle(date: "3/10/2021", title: "Wednesday"),
              TimePlannerTitle(date: "3/11/2021", title: "Thursday"),
              TimePlannerTitle(date: "3/11/2021", title: "Friday"),
              TimePlannerTitle(date: "3/11/2021", title: "Saturday"),
            ],
            tasks: controller.getTask,
          )),
    );
  }
}
