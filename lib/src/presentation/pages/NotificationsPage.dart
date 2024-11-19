import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/notification_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/notification_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];
  final NotificationRepository _notificationRepository = NotificationRepository();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      // Cambiar el ID del usuario según el rol actual
      const int ownerId = 1; // Ejemplo: Usuario propietario
      notifications = await _notificationRepository.getNotificationsByUser(ownerId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar notificaciones: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int notificationId, int index) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      setState(() {
        notifications[index] = notifications[index].copyWith(read: true);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al marcar como leída: $e')),
      );
    }
  }

  Future<void> _deleteNotification(int notificationId, int index) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      setState(() {
        notifications.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notificación eliminada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar notificación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isNotEmpty
          ? ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(notification.id!, index);
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(notification.notificationType),
                subtitle: Text(notification.content),
                trailing: IconButton(
                  icon: Icon(
                    notification.read ? Icons.done : Icons.markunread,
                    color: notification.read ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    if (!notification.read) {
                      _markAsRead(notification.id!, index);
                    }
                  },
                ),
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No tienes notificaciones.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}