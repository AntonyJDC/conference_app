import 'package:conference_app/data/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewApiProvider {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<List<ReviewModel>> getReviewsByEvent(String eventId) async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/$eventId/get'));

    if (res.statusCode == 200) {
      final List decoded = jsonDecode(res.body);
      return decoded.map((e) => ReviewModel.fromMap(e)).toList();
    } else {
      throw Exception('Error cargando reseñas desde la API');
    }
  }

  Future<void> postReview(ReviewModel review) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reviews/${review.eventId}/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(review.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Error al enviar reseña');
    }
  }
}
