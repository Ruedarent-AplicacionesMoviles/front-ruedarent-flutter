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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);
      if (vehicleTypeId != -1) {
        final data = await VehicleRepository().getAllVehicles();
        setState(() {
          vehicles = data.where((v) => v.vehicleTypeId == vehicleTypeId).toList();
        });
      }
    } catch (e) {
      print('Error al cargar vehículos por categoría: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<int> _getVehicleTypeIdByName(String name) async {
    final repo = VehicleTypeRepository();
    final type = await repo.getVehicleTypeByName(name);
    return type?.id ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos en ${widget.categoryName}'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : vehicles.isNotEmpty
            ? ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleDetailPage(vehicle: vehicle),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: vehicle.photos != null && vehicle.photos!.isNotEmpty
                            ? Image.network(vehicle.photos!, fit: BoxFit.cover)
                            : const Icon(Icons.directions_car, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.brand,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(vehicle.model, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(
                              'S/. ${vehicle.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            Text(vehicle.location, style: const TextStyle(color: Colors.grey)),
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
            : const Center(child: Text('No hay vehículos disponibles en esta categoría.')),
      ),
    );
  }
}
