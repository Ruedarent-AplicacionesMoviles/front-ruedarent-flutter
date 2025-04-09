import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/vehicle/VehicleDetailForOwnerPage.dart';

class CategoryVehiclesPage extends StatefulWidget {
  final String categoryName;

  const CategoryVehiclesPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryVehiclesPageState createState() => _CategoryVehiclesPageState();
}

class _CategoryVehiclesPageState extends State<CategoryVehiclesPage> {
  List<VehicleModel> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);
    if (vehicleTypeId != -1) {
      final data = await VehicleRepository().getAllVehicles();
      setState(() {
        vehicles = data.where((v) => v.vehicleTypeId == vehicleTypeId).toList();
      });
    }
  }

  Future<int> _getVehicleTypeIdByName(String name) async {
    final repo = VehicleTypeRepository();
    final type = await repo.getVehicleTypeByName(name);
    return type?.id ?? -1;
  }

  void _confirmDelete(BuildContext context, int vehicleId, int ownerId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Vehículo'),
        content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteVehicle(vehicleId, ownerId);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVehicle(int id, int ownerId) async {
    try {
      final success = await VehicleRepository().deleteVehicle(id, ownerId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo eliminado')),
        );
        _loadVehicles();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  Future<void> _addVehicle() async {
    int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);

    final result = await Navigator.pushNamed(
      context,
      '/add-vehicle',
      arguments: {'vehicleTypeId': vehicleTypeId},
    );

    if (result == true) _loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos de ${widget.categoryName}'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addVehicle),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: vehicles.isEmpty
            ? const Center(child: Text('No hay vehículos disponibles en esta categoría.'))
            : ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VehicleDetailForOwnerPage(vehicle: vehicle),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Image(
                        image: vehicle.photos != null && vehicle.photos!.isNotEmpty
                            ? NetworkImage(vehicle.photos!) as ImageProvider
                            : const AssetImage('assets/images/vehicles/default.png'),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.brand,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('S/. ${vehicle.price.toStringAsFixed(2)}'),
                            Text(vehicle.location),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/edit-vehicle',
                                arguments: vehicle,
                              );
                              if (result == true) _loadVehicles();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, vehicle.id!, vehicle.ownerId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
