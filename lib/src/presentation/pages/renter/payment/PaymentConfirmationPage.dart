import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart';

class PaymentConfirmationPage extends StatelessWidget {
  final String cardType;
  final String lastDigits;

  const PaymentConfirmationPage({
    Key? key,
    required this.cardType,
    required this.lastDigits,
  }) : super(key: key);

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
              onPressed: () {
                // Navegar a CategoriesPage.dart cuando se presiona "Finalizar compra"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentadorVehiclesPage(), // Asegúrate de que CategoriesPage está bien importado
                  ),
                      (Route<dynamic> route) => false, // Eliminar el historial de navegación
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