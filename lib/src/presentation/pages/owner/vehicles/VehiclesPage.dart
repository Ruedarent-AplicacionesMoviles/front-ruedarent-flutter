import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/bike/BikeCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/scooter/ScooterCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/data/database_helper.dart'; // Importar el helper de SQLite

class VehiclesPage extends StatefulWidget {
  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();  // Cargar los vehículos al iniciar la pantalla
  }

  // Método para cargar los vehículos desde la base de datos
  Future<void> _loadVehicles() async {
    final data = await DatabaseHelper().getVehicles();  // Obtener los vehículos desde la base de datos
    setState(() {
      vehicles = data;  // Actualizar el estado con los vehículos cargados
    });
  }

  // Método para eliminar un vehículo de la base de datos y de la lista visual
  Future<void> _deleteVehicle(int index) async {
    int id = vehicles[index]['id']; // Obtener el id del vehículo
    await DatabaseHelper().deleteVehicle(id);  // Eliminar de la base de datos
    setState(() {
      vehicles.removeAt(index);  // Remover de la lista visual
    });
  }

  // Mostrar el cuadro de diálogo de confirmación para eliminar un vehículo
  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
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
                _deleteVehicle(index);  // Llamar al método para eliminar el vehículo
                Navigator.of(context).pop();  // Cerrar el cuadro de diálogo
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
        title: const Text('Categorías de Vehículos'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScooterCategoryPage(),
                          ),
                        );
                      } else if (vehicles[index]['name'] == 'Bike') {
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
                            Image(
                              image: vehicles[index]['image'] != null && vehicles[index]['image'].isNotEmpty
                                  ? NetworkImage(vehicles[index]['image']) // Cargar imagen desde URL si existe
                                  : AssetImage('assets/images/vehicles/bicileta.png'), // Cargar imagen predeterminada
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
                                    vehicles[index]['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    vehicles[index]['info'] ?? '',
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
                                    _showDeleteDialog(context, index);  // Mostrar el diálogo de confirmación
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-category',
                                      arguments: vehicles[index],  // Pasar el vehículo a editar
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
              onPressed: () async {
                // Navegar a la página para agregar categorías y esperar el resultado
                final result = await Navigator.pushNamed(context, '/add-category');

                // Verificar si se ha añadido una nueva categoría
                if (result == true) {
                  _loadVehicles();  // Recargar la lista de vehículos si se agregó uno nuevo
                }
              },
              child: const Text('AGREGAR +'),
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