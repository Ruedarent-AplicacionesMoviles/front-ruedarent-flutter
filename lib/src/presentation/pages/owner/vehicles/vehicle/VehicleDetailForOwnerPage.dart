import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';

class VehicleDetailForOwnerPage extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailForOwnerPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _VehicleDetailForOwnerPageState createState() => _VehicleDetailForOwnerPageState();
}

class _VehicleDetailForOwnerPageState extends State<VehicleDetailForOwnerPage> {
  late VehicleModel _vehicle;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle; // Inicializamos con los datos del vehículo pasado
  }

  // Método para manejar el retorno de la página de edición
  Future<void> _navigateToEditPage(BuildContext context) async {
    // Navegar a la página de edición y esperar el vehículo actualizado
    final updatedVehicle = await Navigator.pushNamed(
      context,
      '/edit-vehicle',
      arguments: _vehicle, // Pasar el vehículo actual como argumento
    );

    // Verificar si el vehículo fue actualizado y asignarlo a _vehicle
    if (updatedVehicle != null && updatedVehicle is VehicleModel) {
      setState(() {
        _vehicle = updatedVehicle; // Actualizar los detalles del vehículo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _vehicle.brand, // Mostrar solo la marca en el AppBar
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Agregar puntos suspensivos si es muy largo
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar a la página de edición
              _navigateToEditPage(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Mostrar advertencia antes de eliminar
              _confirmDelete(context, _vehicle.id!);
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
              child: _vehicle.photos != null && _vehicle.photos!.isNotEmpty
                  ? Image.network(_vehicle.photos!, height: 200, fit: BoxFit.cover)
                  : const Icon(Icons.directions_car, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Detalles completos del título en el cuerpo de la página
            Text(
              _vehicle.brand, // Marca
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _vehicle.model, // Modelo
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),

            // Precio
            Text(
              'Precio: S/. ${_vehicle.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            // Ubicación
            Text(
              'Ubicación: ${_vehicle.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Disponibilidad
            Text(
              'Disponibilidad: ${_vehicle.availability}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
            // Descripción
            if (_vehicle.description != null && _vehicle.description!.isNotEmpty)
              Text(
                _vehicle.description!,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

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
}