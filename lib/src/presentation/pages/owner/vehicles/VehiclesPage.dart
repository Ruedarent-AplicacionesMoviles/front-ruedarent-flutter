import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/bike/BikeCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/scooter/ScooterCategoryPage.dart';

class VehiclesPage extends StatefulWidget {
  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<VehicleTypeModel> vehicleTypes = []; // Cambia el tipo a VehicleTypeModel

  @override
  void initState() {
    super.initState();
    _loadVehicleTypes(); // Cargar los tipos de vehículos al iniciar la pantalla
  }

  // Método para cargar los tipos de vehículos desde la base de datos
  Future<void> _loadVehicleTypes() async {
    final data = await VehicleTypeRepository().getVehicleTypes(); // Obtener los tipos de vehículos desde el repositorio
    setState(() {
      vehicleTypes = data.map((e) => VehicleTypeModel.fromMap(e)).toList(); // Mapear los datos a VehicleTypeModel
    });
  }

  // Método para eliminar un tipo de vehículo de la base de datos y de la lista visual
  Future<void> _deleteVehicleType(int index) async {
    int id = vehicleTypes[index].id!; // Obtener el id del tipo de vehículo
    await VehicleTypeRepository().deleteVehicleType(id); // Eliminar de la base de datos
    setState(() {
      vehicleTypes.removeAt(index); // Remover de la lista visual
    });
  }

  // Mostrar el cuadro de diálogo de confirmación para eliminar un tipo de vehículo
  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar este tipo de vehículo?'),
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
                _deleteVehicleType(index); // Llamar al método para eliminar el tipo de vehículo
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
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
                itemCount: vehicleTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navegar a la página correspondiente según el tipo de vehículo
                      if (vehicleTypes[index].name == 'Scooter Electrónico') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScooterCategoryPage(),
                          ),
                        );
                      } else if (vehicleTypes[index].name == 'Bike') {
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
                              image: vehicleTypes[index].image != null && vehicleTypes[index].image!.isNotEmpty
                                  ? NetworkImage(vehicleTypes[index].image!) as ImageProvider
                                  : const AssetImage('assets/images/vehicles/default.png'), // Imagen por defecto
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
                                    vehicleTypes[index].info ?? '', // Muestra la información de la categoría
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
                                    _showDeleteDialog(context, index); // Mostrar el diálogo de confirmación
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-category',
                                      arguments: vehicleTypes[index],  // Pasar el tipo de vehículo a editar
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
                // Navegar a la página para agregar un nuevo tipo de vehículo y esperar el resultado
                final result = await Navigator.pushNamed(context, '/add-category');

                // Verificar si se ha añadido un nuevo tipo de vehículo
                if (result == true) {
                  _loadVehicleTypes(); // Recargar la lista de tipos de vehículos si se agregó uno nuevo
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