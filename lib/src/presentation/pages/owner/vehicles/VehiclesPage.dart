import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/CategoryVehiclesPage.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<VehicleTypeModel> vehicleTypes = [];

  @override
  void initState() {
    super.initState();
    _loadVehicleTypes(); // Cargar los tipos de vehículos al iniciar la pantalla
  }

  Future<void> _loadVehicleTypes() async {
    final data = await VehicleTypeRepository().getVehicleTypes();
    setState(() {
      vehicleTypes = data.map((e) => VehicleTypeModel.fromMap(e)).toList();
    });
  }

  Future<void> _logout() async {
    // Aquí puedes limpiar cualquier dato de sesión, como un token de autenticación
    Navigator.of(context).popUntil((route) => route.isFirst); // Cierra todas las pantallas hasta llegar a la primera
    Navigator.pushReplacementNamed(context, '/login'); // Redirige a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _logout(); // Llama a _logout al presionar el botón de retroceso
          },
        ),
        title: const Text('Categorías de Vehículos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: vehicleTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryVehiclesPage(
                            categoryName: vehicleTypes[index].name,
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
                              image: vehicleTypes[index].image != null && vehicleTypes[index].image!.isNotEmpty
                                  ? NetworkImage(vehicleTypes[index].image!) as ImageProvider
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}