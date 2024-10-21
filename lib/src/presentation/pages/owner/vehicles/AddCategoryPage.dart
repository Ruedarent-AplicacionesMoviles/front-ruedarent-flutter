import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

class AddCategoryPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite el desplazamiento si el contenido es largo
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
              ),
              TextField(
                controller: _infoController,
                decoration: const InputDecoration(labelText: 'Información de la categoría'),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Ruta de la imagen'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validar que los campos no estén vacíos
                  if (_nameController.text.isEmpty ||
                      _infoController.text.isEmpty ||
                      _imageController.text.isEmpty) {
                    _showErrorDialog(context, 'Todos los campos son obligatorios');
                    return;
                  }

                  // Crear una instancia de VehicleTypeModel
                  final newCategory = VehicleTypeModel(
                    name: _nameController.text,
                    info: _infoController.text,
                    image: _imageController.text,
                  );

                  try {
                    // Insertar la nueva categoría utilizando el repositorio
                    await VehicleTypeRepository().insertVehicleType(newCategory.toMap());
                    // Volver a la pantalla anterior y actualizar la lista
                    Navigator.pop(context, true);
                  } catch (e) {
                    // Imprimir el error exacto para depurar
                    print('Error al guardar la categoría: $e');
                    _showErrorDialog(context, 'Hubo un error al guardar la categoría');
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