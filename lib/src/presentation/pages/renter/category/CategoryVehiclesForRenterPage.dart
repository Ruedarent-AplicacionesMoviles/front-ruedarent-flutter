import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/vehicle/VehicleDetailPage.dart';

class CategoryVehiclesForRenterPage extends StatefulWidget {
  final String categoryName;

  const CategoryVehiclesForRenterPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryVehiclesForRenterPageState createState() => _CategoryVehiclesForRenterPageState();
}

class _CategoryVehiclesForRenterPageState extends State<CategoryVehiclesForRenterPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos en ${widget.categoryName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: vehicles.isNotEmpty
            ? ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Al hacer clic, navega a la página de detalles del vehículo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailPage(vehicle: vehicles[index]),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Imagen del vehículo (URL o asset local si no tiene foto)
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: vehicles[index].photos != null && vehicles[index].photos!.isNotEmpty
                            ? Image.network(vehicles[index].photos!, fit: BoxFit.cover)
                            : const Icon(Icons.directions_car, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      // Información del vehículo
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicles[index].brand,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              vehicles[index].model,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'S/. ${vehicles[index].price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              vehicles[index].location,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : Center(
          child: const Text('No hay vehículos disponibles en esta categoría.'),
        ),
      ),
    );
  }
}