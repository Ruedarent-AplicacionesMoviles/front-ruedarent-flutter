import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/category/CategoryVehiclesForRenterPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/filter/FiltersPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/filter/FilteredVehiclePage.dart';

class RentadorVehiclesPage extends StatefulWidget {
  const RentadorVehiclesPage({super.key});

  @override
  _RentadorVehiclesPageState createState() => _RentadorVehiclesPageState();
}

class _RentadorVehiclesPageState extends State<RentadorVehiclesPage> {
  final VehicleTypeRepository _vehicleTypeRepository = VehicleTypeRepository();

  List<VehicleTypeModel> vehicleTypes = [];
  String _searchTerm = '';
  String? _selectedAvailability;
  String? _selectedLocation;
  RangeValues _priceRange = const RangeValues(0, 1000);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVehicleTypes();
  }

  Future<void> _loadVehicleTypes() async {
    try {
      final data = await _vehicleTypeRepository.getVehicleTypes();
      setState(() {
        vehicleTypes = data;
      });
    } catch (e) {
      print('Error al cargar tipos de vehículo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías')),
      );
    }
  }

  void _navigateToFilters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersPage(
          selectedAvailability: _selectedAvailability,
          selectedLocation: _selectedLocation,
          priceRange: _priceRange,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedAvailability = result['availability'];
        _selectedLocation = result['location'];
        _priceRange = result['priceRange'];
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredVehiclesPage(
            availability: _selectedAvailability,
            location: _selectedLocation,
            priceRange: _priceRange,
          ),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    final userId = context.read<UserProvider>().userId!;

    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/user-profile', arguments: userId);
        break;
      case 2:
        _navigateToFilters();
        break;
      case 3:
        Navigator.pushNamed(context, '/reservations');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicleTypes = vehicleTypes
        .where((type) => type.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Disponibles'),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar vehículos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchTerm = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredVehicleTypes.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredVehicleTypes.length,
                itemBuilder: (context, index) {
                  final vehicleType = filteredVehicleTypes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryVehiclesForRenterPage(
                            categoryName: vehicleType.name,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image(
                              image: vehicleType.image != null && vehicleType.image!.isNotEmpty
                                  ? NetworkImage(vehicleType.image!)
                                  : const AssetImage('assets/images/vehicles/default.png')
                              as ImageProvider,
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
                                    vehicleType.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    vehicleType.info ?? '',
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
                child: Text('No se encontraron vehículos.', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorías'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_list), label: 'Filtros'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Reservas'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
