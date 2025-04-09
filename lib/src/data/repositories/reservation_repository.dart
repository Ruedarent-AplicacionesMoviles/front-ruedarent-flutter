// src/data/repositories/reservation_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation_model.dart';
import '../api_constants.dart';

class ReservationRepository {
  final String _host = ApiConstants.host;
  final String _path = '/reservations.php';

  // Crear una nueva reserva
  Future<int> createReservation(ReservationModel reservation) async {
    final uri = Uri.parse("$_host$_path");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reservation.toMap()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception("Error al crear la reserva: ${response.body}");
    }
  }

  // Obtener reservas por ID de usuario (renterId)
  Future<List<ReservationModel>> getReservationsByUserId(int userId) async {
    final uri = Uri.parse('$_host$_path?renterId=$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<ReservationModel>.from(data.map((e) => ReservationModel.fromMap(e)));
    } else {
      throw Exception("Error al obtener reservas: ${response.body}");
    }
  }

  // Eliminar reserva
  Future<bool> deleteReservation(int id) async {
    final uri = Uri.parse('$_host$_path?id=$id');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al eliminar reserva: ${response.body}");
    }
  }

  // (Opcional) Actualizar reserva
  Future<bool> updateReservation(ReservationModel reservation) async {
    final uri = Uri.parse('$_host$_path');
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reservation.toMap()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al actualizar reserva: ${response.body}");
    }
  }
}
