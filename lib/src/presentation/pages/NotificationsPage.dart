import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/notification_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/notification_repository.dart';
import 'package:provider/provider.dart';
import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];
  final NotificationRepository _notificationRepository = NotificationRepository();
  late final int _userId;

  @override
  void initState() {
    super.initState();
    _userId = context.read<UserProvider>().userId!;
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await _notificationRepository.getNotificationsByUser(_userId);
      setState(() {
        notifications = data;
      });
    } catch (e) {
      print('Error al cargar notificaciones: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar notificaciones')),
      );
    }
  }

  Future<void> _deleteNotification(int notificationId, int index) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      setState(() {
        notifications.removeAt(index);
      });
    } catch (e) {
      print('Error al eliminar notificación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar notificación')),
      );
    }
  }

  Future<void> _markAsRead(NotificationModel notification, int index) async {
    if (notification.read) return;

    try {
      await _notificationRepository.markAsRead(notification.id!);
      setState(() {
        notifications[index] = notification.copyWith(read: true);
      });
    } catch (e) {
      print('Error al marcar como leída: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al marcar como leída')),
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
              child: const Icon(Icons.delete, color: Colors.white),
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
                onTap: () => _markAsRead(notification, index),
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
