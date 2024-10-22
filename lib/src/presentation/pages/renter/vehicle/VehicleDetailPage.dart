import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/vehicle/ConfirmOrderPage.dart';

class VehicleDetailPage extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.brand} ${vehicle.model}'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del vehículo
            Center(
              child: vehicle.photos != null && vehicle.photos!.isNotEmpty
                  ? Image.network(vehicle.photos!, height: 200, fit: BoxFit.cover)
                  : const Icon(Icons.directions_car, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Marca y modelo
            Text(
              '${vehicle.brand} ${vehicle.model}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Precio
            Text(
              'Precio: S/. ${vehicle.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            // Ubicación
            Text(
              'Ubicación: ${vehicle.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Disponibilidad
            Text(
              'Disponibilidad: ${vehicle.availability}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
            // Descripción
            if (vehicle.description != null && vehicle.description!.isNotEmpty)
              Text(
                vehicle.description!,
                style: const TextStyle(fontSize: 16),
              ),
            const Spacer(),
            // Botón para alquilar el vehículo centrado y con buen padding inferior
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Espaciado superior e inferior para el botón
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Navegar a la página de confirmación de orden
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmOrderPage(vehicle: vehicle), // Pasar el vehículo a ConfirmOrderPage
                      ),
                    );
                  },
                  child: const Text(
                    'Alquilar Vehículo',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}