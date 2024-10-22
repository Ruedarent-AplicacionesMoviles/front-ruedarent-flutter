import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

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
    _loadVehicles(); // Cargar vehículos al iniciar la pantalla
  }

  // Método para cargar vehículos de la categoría
  Future<void> _loadVehicles() async {
    int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);
    if (vehicleTypeId != -1) {
      final data = await VehicleRepository().getAllVehicles();
      setState(() {
        // Filtrar los vehículos según el tipo
        vehicles = data.where((vehicle) => vehicle.vehicleTypeId == vehicleTypeId).toList();
      });
    }
  }

  // Método para obtener el ID del tipo de vehículo por nombre
  Future<int> _getVehicleTypeIdByName(String name) async {
    final vehicleTypeRepository = VehicleTypeRepository();
    final vehicleType = await vehicleTypeRepository.getVehicleTypeByName(name);
    return vehicleType?.id ?? -1; // Retorna -1 si no se encuentra
  }

  // Método para eliminar un vehículo
  Future<void> _deleteVehicle(int id) async {
    await VehicleRepository().deleteVehicle(id);
    _loadVehicles(); // Recargar los vehículos después de eliminar
  }

  // Método para agregar un nuevo vehículo
  Future<void> _addVehicle() async {
    int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);

    Navigator.pushNamed(
      context,
      '/add-vehicle',
      arguments: {'vehicleTypeId': vehicleTypeId}, // Pasar el ID del tipo de vehículo
    ).then((result) {
      if (result == true) {
        _loadVehicles(); // Recargar vehículos si se agregó uno nuevo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos de ${widget.categoryName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addVehicle, // Agregar nuevo vehículo
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: vehicles.isNotEmpty
            ? ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image(
                      image: vehicles[index].photos != null && vehicles[index].photos!.isNotEmpty
                          ? NetworkImage(vehicles[index].photos!) as ImageProvider
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
                            vehicles[index].brand,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(vehicles[index].description ?? ''),
                          const SizedBox(height: 8),
                          Text('Precio: S/. ${vehicles[index].price}'), // Muestra el precio
                          Text('Ubicación: ${vehicles[index].location}'), // Muestra la ubicación
                          Text('Disponibilidad: ${vehicles[index].availability}'), // Muestra disponibilidad
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        // Navegar a la página de edición y pasar el vehículo
                        Navigator.pushNamed(
                          context,
                          '/edit-vehicle',
                          arguments: vehicles[index], // Pasar el vehículo a editar
                        ).then((result) {
                          if (result == true) {
                            _loadVehicles(); // Recargar vehículos si se hizo un cambio
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteVehicle(vehicles[index].id!); // Eliminar vehículo
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : Center(child: const Text('No hay vehículos disponibles en esta categoría.')),
      ),
    );
  }
}