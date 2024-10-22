import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/category/CategoryVehiclesForRenterPage.dart';

class RentadorVehiclesPage extends StatefulWidget {
  const RentadorVehiclesPage({super.key});

  @override
  _RentadorVehiclesPageState createState() => _RentadorVehiclesPageState();
}

class _RentadorVehiclesPageState extends State<RentadorVehiclesPage> {
  List<VehicleTypeModel> vehicleTypes = [];
  String _searchTerm = ''; // Variable para manejar el término de búsqueda
  int _selectedIndex = 0; // Índice de la página seleccionada en la barra

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

  // Manejar la navegación al cambiar de índice en la barra de navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Manejar la navegación entre las pantallas según el índice
    switch (index) {
      case 0:
      // Mantenerse en la pantalla actual
        break;
      case 1:
      // Navegar a la pantalla de alquiler de vehículos
        Navigator.pushReplacementNamed(context, '/rent');
        break;
      case 2:
      // Navegar a la pantalla de perfil del usuario
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar los resultados según el término de búsqueda
    List<VehicleTypeModel> filteredVehicleTypes = vehicleTypes
        .where((type) => type.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Disponibles'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar vehículos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Mostrar resultados filtrados
            Expanded(
              child: filteredVehicleTypes.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredVehicleTypes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryVehiclesForRenterPage(
                            categoryName: filteredVehicleTypes[index].name,
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
                              image: filteredVehicleTypes[index].image != null &&
                                  filteredVehicleTypes[index].image!.isNotEmpty
                                  ? NetworkImage(filteredVehicleTypes[index].image!)
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
                                    filteredVehicleTypes[index].name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    filteredVehicleTypes[index].info ?? '',
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
                  'No se encontraron vehículos.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Mis Alquileres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped, // Llama al método para manejar la navegación
      ),
    );
  }
}