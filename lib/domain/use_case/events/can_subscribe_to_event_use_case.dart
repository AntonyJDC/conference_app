import 'package:conference_app/data/models/event_model.dart';
import 'check_event_status_use_case.dart';

class CanSubscribeToEventUseCase {
  final CheckEventStatusUseCase _checkStatus = CheckEventStatusUseCase();

  Future<bool> execute(EventModel event) async {
    final isPast = _checkStatus.execute(event);
    final hasSpots = event.spotsLeft > 0;

    return !isPast && hasSpots;
  }
}
