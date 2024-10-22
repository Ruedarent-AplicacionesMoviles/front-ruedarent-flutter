import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/bike/BikeCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/scooter/ScooterCategoryPage.dart';

void main() {
  runApp(VehiclesApp());
}

class VehiclesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: VehiclesPage(),
    );
  }
}

class VehiclesPage extends StatefulWidget {
  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Map<String, String>> vehicles = [
    {
      'name': 'Bike',
      'info': 'Info about the bike',
      'image': 'assets/images/vehicles/bicicleta.png',
      'location': 'Lima',
      'price': '10',
      'availability': 'Available',
    },
    {
      'name': 'Scooter Electrónico',
      'info': 'Info about the scooter',
      'image': 'assets/images/vehicles/scooter.png',
      'location': 'Cusco',
      'price': '20',
      'availability': 'Reserved',
    },
  ];

  String searchQuery = '';
  String selectedLocation = 'All';
  String selectedAvailability = 'All';
  RangeValues selectedPriceRange = const RangeValues(0, 100);

  // Variables temporales para los filtros
  String tempLocation = 'All';
  String tempAvailability = 'All';
  RangeValues tempPriceRange = const RangeValues(0, 100);

  // Método para mostrar el cuadro de diálogo de confirmación
  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() {
                  vehicles.removeAt(index); // Elimina la categoría de la lista
                });
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo después de eliminar
              },
            ),
          ],
        );
      },
    );
  }

  // Diálogo para seleccionar filtros
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) { // Cambiado a setStateDialog para diferenciar
            return AlertDialog(
              title: const Text('Filtrar vehículos'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempLocation,
                    onChanged: (String? newValue) {
                      setStateDialog(() {
                        tempLocation = newValue!;
                      });
                    },
                    items: <String>['All', 'Lima', 'Cusco', 'Arequipa']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('Seleccionar ubicación'),
                  ),
                  DropdownButton<String>(
                    value: tempAvailability,
                    onChanged: (String? newValue) {
                      setStateDialog(() {
                        tempAvailability = newValue!;
                      });
                    },
                    items: <String>['All', 'Available', 'Reserved']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('Disponibilidad'),
                  ),
                  RangeSlider(
                    values: tempPriceRange,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels(
                      tempPriceRange.start.round().toString(),
                      tempPriceRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues newRange) {
                      setStateDialog(() {
                        tempPriceRange = newRange;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() { // Esto actualizará el estado del widget principal
                      // Actualiza los filtros reales solo cuando se presiona "Aplicar"
                      selectedLocation = tempLocation;
                      selectedAvailability = tempAvailability;
                      selectedPriceRange = tempPriceRange;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredVehicles = vehicles.where((vehicle) {
      final matchesSearchQuery =
          searchQuery.isEmpty || vehicle['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesLocation = selectedLocation == 'All' || vehicle['location'] == selectedLocation;
      final matchesAvailability =
          selectedAvailability == 'All' || vehicle['availability'] == selectedAvailability;
      final price = int.parse(vehicle['price']!);
      final matchesPrice = price >= selectedPriceRange.start && price <= selectedPriceRange.end;

      return matchesSearchQuery && matchesLocation && matchesAvailability && matchesPrice;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Buscar vehículos',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            ElevatedButton(
              onPressed: _showFilterDialog,
              child: const Text('Filtrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredVehicles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (filteredVehicles[index]['name'] == 'Scooter Electrónico') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScooterCategoryPage(),
                          ),
                        );
                      } else if (filteredVehicles[index]['name'] == 'Bike') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BikeCategoryPage(),
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              filteredVehicles[index]['image']!,
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
                                    filteredVehicles[index]['name']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    filteredVehicles[index]['info']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.green),
                                  onPressed: () {
                                    _showDeleteDialog(context, index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-vehicle',
                                      arguments: filteredVehicles[index],
                                    );
                                  },
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-vehicle');
              },
              child: const Text('ADD +'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
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
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}