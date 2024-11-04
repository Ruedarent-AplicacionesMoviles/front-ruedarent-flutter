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

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // Ejemplo de notificaciones simuladas
    notifications = [
      NotificationModel(
        id: 1,
        userId: 1,
        notificationType: 'Reservación Nueva',
        content: 'Tienes una nueva reservación.',
        timestamp: DateTime.now(),
        read: false,
      ),
      NotificationModel(
        id: 2,
        userId: 1,
        notificationType: 'Cambio de Reservación',
        content: 'Una de tus reservaciones ha sido actualizada.',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        read: true,
      ),
      NotificationModel(
        id: 3,
        userId: 1,
        notificationType: 'Recordatorio',
        content: 'No olvides confirmar tu reservación.',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        read: false,
      ),
    ];

    setState(() {});
  }


  Future<void> _deleteNotification(int notificationId, int index) async {
    await _notificationRepository.deleteNotification(notificationId);
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
      ),
      body: notifications.isNotEmpty
          ? ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(notification.id!, index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificación eliminada')),
              );
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
                trailing: Icon(
                  notification.read ? Icons.done : Icons.markunread,
                  color: notification.read ? Colors.green : Colors.grey,
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
