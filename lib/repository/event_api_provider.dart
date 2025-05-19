import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventApiProvider {
  
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<int> fetchRemoteVersion() async {
    final res = await http.get(Uri.parse('$baseUrl/version'));
    return jsonDecode(res.body)['version'] ?? 0;
  }

  Future<List<EventModel>> fetchRemoteEvents() async {
    final res = await http.get(Uri.parse('$baseUrl/events/'));

    if (res.statusCode != 200) {
      throw Exception('Error fetching events');
    }

    final List decoded = jsonDecode(res.body);

    return decoded.map((e) => EventModel.fromMap(e)).toList();
  }
}
