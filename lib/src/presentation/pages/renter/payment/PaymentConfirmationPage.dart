import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/notification_repository.dart';
import 'package:front_ruedarent_flutter/src/data/models/notification_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart';

class PaymentConfirmationPage extends StatelessWidget {
  final String cardType;
  final String lastDigits;

  const PaymentConfirmationPage({
    Key? key,
    required this.cardType,
    required this.lastDigits,
  }) : super(key: key);

  // Método para crear una notificación para el propietario
  Future<void> _createNotificationForOwner(BuildContext context) async {
    try {
      final notificationRepository = NotificationRepository();

      // Supongamos que el propietario tiene userId = 1 (ajústalo a tu lógica real)
      const int ownerId = 1;

      // Crear el modelo de notificación
      final notification = NotificationModel(
        userId: ownerId,
        notificationType: 'Reservación Nueva',
        content: 'Se ha confirmado una nueva reservación para tu vehículo.',
        timestamp: DateTime.now(),
        read: false,
      );

      // Insertar la notificación en la base de datos
      await notificationRepository.insertNotification(notification);

      // Mostrar mensaje de éxito (opcional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notificación enviada al propietario')),
      );
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear notificación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Confirmado'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Imagen de confirmación de pago
            Image.asset('assets/images/payment/pago.png', height: 150),
            const SizedBox(height: 30),
            const Text(
              'PAGO CONFIRMADO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tu orden fue procesada exitosamente utilizando la tarjeta $cardType ****$lastDigits',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Mira el estado de tu compra en la sección pedidos',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                // Crear la notificación para el propietario
                await _createNotificationForOwner(context);

                // Navegar de vuelta a la página de vehículos
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentadorVehiclesPage(),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Finalizar compra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}