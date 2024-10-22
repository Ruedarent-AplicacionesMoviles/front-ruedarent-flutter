import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';

class VehicleDetailForOwnerPage extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailForOwnerPage({Key? key, required this.vehicle}) : super(key: key);

  // Método para mostrar advertencia antes de eliminar
  void _confirmDelete(BuildContext context, int vehicleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Vehículo'),
          content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                await VehicleRepository().deleteVehicle(vehicleId); // Eliminar vehículo
                Navigator.pop(context); // Regresar a la pantalla anterior después de eliminar
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.brand} ${vehicle.model}'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar a la página de edición y pasar el vehículo
              Navigator.pushNamed(
                context,
                '/edit-vehicle',
                arguments: vehicle,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Mostrar advertencia antes de eliminar
              _confirmDelete(context, vehicle.id!);
            },
          ),
        ],
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
          ],
        ),
      ),
    );
  }
}