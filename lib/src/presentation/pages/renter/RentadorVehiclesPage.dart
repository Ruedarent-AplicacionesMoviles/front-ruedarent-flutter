import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/category/CategoryVehiclesForRenterPage.dart'; // Asegúrate de importar correctamente la pantalla

class RentadorVehiclesPage extends StatefulWidget {
  const RentadorVehiclesPage({super.key});

  @override
  _RentadorVehiclesPageState createState() => _RentadorVehiclesPageState();
}

class _RentadorVehiclesPageState extends State<RentadorVehiclesPage> {
  List<VehicleTypeModel> vehicleTypes = [];

  @override
  void initState() {
    super.initState();
    _loadVehicleTypes(); // Cargar los tipos de vehículos al iniciar la pantalla
  }

  // Método para cargar los tipos de vehículos desde la base de datos
  Future<void> _loadVehicleTypes() async {
    final data = await VehicleTypeRepository().getVehicleTypes();
    setState(() {
      vehicleTypes = data.map((e) => VehicleTypeModel.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Disponibles'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: vehicleTypes.isNotEmpty
            ? ListView.builder(
          itemCount: vehicleTypes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Al hacer clic, navega a la página de vehículos en esa categoría
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryVehiclesForRenterPage(
                      categoryName: vehicleTypes[index].name, // Pasar el nombre de la categoría
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: vehicleTypes[index].image != null &&
                            vehicleTypes[index].image!.isNotEmpty
                            ? NetworkImage(vehicleTypes[index].image!)
                            : const AssetImage(
                            'assets/images/vehicles/default.png'),
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
                              vehicleTypes[index].name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              vehicleTypes[index].info ?? '',
                              style: const TextStyle(fontSize: 16),
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
            : const Center(
          child: Text(
            'No hay vehículos disponibles.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}