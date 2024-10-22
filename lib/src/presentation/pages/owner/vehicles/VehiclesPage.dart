// lib/src/presentation/pages/owner/vehicles/VehiclesPage.dart

import 'dart:io';
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

  // Método para cargar los tipos de vehículos desde la base de datos
  Future<void> _loadVehicleTypes() async {
    final data = await VehicleTypeRepository().getVehicleTypes();
    setState(() {
      vehicleTypes = data.map((e) => VehicleTypeModel.fromMap(e)).toList();
    });
  }

  // Método para eliminar un tipo de vehículo de la base de datos y de la lista visual
  Future<void> _deleteVehicleType(int index) async {
    int id = vehicleTypes[index].id!;
    await VehicleTypeRepository().deleteVehicleType(id);
    setState(() {
      vehicleTypes.removeAt(index);
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deleteVehicleType(index);
                Navigator.of(context).pop();
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
                      // Navegar a la página de vehículos de la categoría seleccionada
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
                            vehicleTypes[index].image != null && vehicleTypes[index].image!.isNotEmpty
                                ? Image.file(
                              File(vehicleTypes[index].image!),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                                : const Image(
                              image: AssetImage('assets/images/vehicles/default.png'), // Imagen por defecto
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
                                  onPressed: () async {
                                    // Navegar a la página de edición y pasar el tipo de vehículo seleccionado a editar
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/edit-category-vehicle',
                                      arguments: vehicleTypes[index], // Pasar el tipo de vehículo a editar
                                    );

                                    // Verificar si se ha realizado algún cambio
                                    if (result == true) {
                                      _loadVehicleTypes(); // Recargar la lista de tipos de vehículos si se actualizó uno
                                    }
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
                final result = await Navigator.pushNamed(context, '/add-category-vehicle');

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
