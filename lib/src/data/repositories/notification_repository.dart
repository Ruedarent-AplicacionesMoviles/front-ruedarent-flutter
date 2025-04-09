import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final String _host = ApiConstants.host;
  final String _path = "/notification.php";

  // Obtener todas las notificaciones de un usuario
  Future<List<NotificationModel>> getNotificationsByUser(int userId) async {
    final uri = Uri.parse("$_host$_path?userId=$userId");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NotificationModel.fromMap(json)).toList();
    } else {
      throw Exception("Error al obtener notificaciones: ${response.body}");
    }
  }

  // Eliminar una notificación
  Future<bool> deleteNotification(int id) async {
    final uri = Uri.parse("$_host$_path?id=$id");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al eliminar notificación: ${response.body}");
    }
  }

  // Crear una notificación
  Future<bool> insertNotification(NotificationModel notification) async {
    final uri = Uri.parse("$_host$_path");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notification.toMap()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error al insertar notificación: ${response.body}");
    }
  }

  // Actualizar toda una notificación
  Future<void> updateNotification(NotificationModel notification) async {
    final uri = Uri.parse("$_host$_path");
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notification.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar notificación: ${response.body}");
    }
  }

  // Marcar una notificación como leída
  Future<void> markAsRead(int id) async {
    final uri = Uri.parse("$_host$_path");
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id': id,
        'read': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al marcar como leída: ${response.body}");
    }
  }
}
