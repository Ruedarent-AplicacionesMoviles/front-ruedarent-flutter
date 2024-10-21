import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';

class AddVehiclePage extends StatelessWidget {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _photosController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final int vehicleTypeId; // ID del tipo de vehículo que se pasa al constructor

  AddVehiclePage({Key? key, required this.vehicleTypeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _photosController,
                decoration: const InputDecoration(labelText: 'URL de la imagen (opcional)'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validar que los campos no estén vacíos
                  if (_brandController.text.isEmpty ||
                      _modelController.text.isEmpty ||
                      _locationController.text.isEmpty ||
                      _priceController.text.isEmpty) {
                    _showErrorDialog(context, 'Todos los campos son obligatorios');
                    return;
                  }

                  // Crear una instancia de VehicleModel
                  final newVehicle = VehicleModel(
                    ownerId: 1, // Asignar el ID del propietario según sea necesario
                    vehicleTypeId: vehicleTypeId,
                    brand: _brandController.text,
                    model: _modelController.text,
                    location: _locationController.text,
                    availability: 'available', // Valor predeterminado
                    price: double.parse(_priceController.text),
                    photos: _photosController.text.isEmpty ? null : _photosController.text,
                    description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                  );

                  try {
                    // Insertar el nuevo vehículo utilizando el repositorio
                    await VehicleRepository().insertVehicle(newVehicle);
                    // Volver a la pantalla anterior y actualizar la lista
                    Navigator.pop(context, true);
                  } catch (e) {
                    print('Error al guardar el vehículo: $e');
                    _showErrorDialog(context, 'Hubo un error al guardar el vehículo');
                  }
                },
                child: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para mostrar un cuadro de diálogo con un mensaje de error
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}