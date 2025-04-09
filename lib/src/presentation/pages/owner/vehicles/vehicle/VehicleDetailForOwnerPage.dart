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
    _vehicle = widget.vehicle;
  }

  Future<void> _navigateToEditPage(BuildContext context) async {
    final updatedVehicle = await Navigator.pushNamed(
      context,
      '/edit-vehicle',
      arguments: _vehicle,
    );

    if (updatedVehicle != null && updatedVehicle is VehicleModel) {
      setState(() {
        _vehicle = updatedVehicle;
      });
    }
  }

  Future<void> _confirmDelete(BuildContext context, int vehicleId, int ownerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Vehículo'),
          content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                try {
                  final success = await VehicleRepository().deleteVehicle(vehicleId, ownerId);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vehículo eliminado correctamente')),
                    );
                    Navigator.pop(context); // Volver atrás después de eliminar
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar vehículo: $e')),
                  );
                }
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
        title: Text(
          _vehicle.brand,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, _vehicle.id!, _vehicle.ownerId),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: _vehicle.photos != null && _vehicle.photos!.isNotEmpty
                  ? Image.network(_vehicle.photos!, height: 200, fit: BoxFit.cover)
                  : const Icon(Icons.directions_car, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              _vehicle.brand,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _vehicle.model,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Text(
              'Precio: S/. ${_vehicle.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Ubicación: ${_vehicle.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Disponibilidad: ${_vehicle.availability}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
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
}
