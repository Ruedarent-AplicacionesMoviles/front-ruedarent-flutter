import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';
import '../api_constants.dart';

class ReviewRepository {
  final String _host = ApiConstants.host;
  final String _path = '/reviews.php';

  // Obtener todas las reseñas de un vehículo
  Future<List<ReviewModel>> getReviewsByVehicle(int vehicleId) async {
    final response = await http.get(Uri.parse("$_host$_path?vehicleId=$vehicleId"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ReviewModel.fromMap(e)).toList();
    } else {
      throw Exception('Error al obtener reseñas: ${response.body}');
    }
  }

  // Obtener reseñas de un usuario
  Future<List<ReviewModel>> getReviewsByUser(int userId) async {
    final response = await http.get(Uri.parse("$_host$_path?userId=$userId"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ReviewModel.fromMap(e)).toList();
    } else {
      throw Exception('Error al obtener reseñas del usuario: ${response.body}');
    }
  }

  // Crear reseña
  Future<int> insertReview(ReviewModel review) async {
    final response = await http.post(
      Uri.parse("$_host$_path"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(review.toMap()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al crear la reseña: ${response.body}');
    }
  }

  // Actualizar reseña
  Future<void> updateReview(ReviewModel review) async {
    final response = await http.put(
      Uri.parse("$_host$_path"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(review.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la reseña: ${response.body}');
    }
  }

  // Eliminar reseña
  Future<void> deleteReview(int id) async {
    final response = await http.delete(Uri.parse("$_host$_path?id=$id"));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la reseña: ${response.body}');
    }
  }

  // Obtener una reseña por ID
  Future<ReviewModel?> getReviewById(int id) async {
    final response = await http.get(Uri.parse("$_host$_path?id=$id"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.isNotEmpty ? ReviewModel.fromMap(data[0]) : null;
    } else {
      throw Exception('Error al obtener reseña por ID: ${response.body}');
    }
  }
}
