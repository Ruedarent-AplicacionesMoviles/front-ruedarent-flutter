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
    },
    {
      'name': 'Scooter Electrónico',
      'info': 'Info about the scooter',
      'image': 'assets/images/vehicles/scooter.png',
    },
  ];

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
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() {
                  vehicles.removeAt(index);  // Elimina la categoría de la lista
                });
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo después de eliminar
              },
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
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (vehicles[index]['name'] == 'Scooter Electrónico') {
                        // Navegar a la página de Scooter Electrónico
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScooterCategoryPage(),
                          ),
                        );
                      } else if (vehicles[index]['name'] == 'Bike') {
                        // Navegar a la página de Bicicleta
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
                              vehicles[index]['image']!,
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
                                    vehicles[index]['name']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    vehicles[index]['info']!,
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
                                    // Mostrar el diálogo de confirmación al hacer clic en eliminar
                                    _showDeleteDialog(context, index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    // Lógica para editar el vehículo
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-vehicle',
                                      arguments: vehicles[index],
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
                // Lógica para añadir un nuevo vehículo
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
        currentIndex: 1, // Establecer el índice actual de la pestaña seleccionada
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