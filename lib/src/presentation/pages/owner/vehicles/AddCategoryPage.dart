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
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  if (_nameController.text.isEmpty ||
                      _infoController.text.isEmpty ||
                      _imageController.text.isEmpty) {
                    _showErrorDialog(context, 'Todos los campos son obligatorios');
                    return;
                  }

                  final newCategory = VehicleTypeModel(
                    name: _nameController.text,
                    info: _infoController.text,
                    image: _imageController.text,
                  );

                  try {
                    /// ✅ Llama al método actualizado que se conecta al backend
                    await VehicleTypeRepository().insertVehicleType(newCategory);

                    // Mostrar confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Categoría guardada exitosamente')),
                    );

                    // Volver y notificar éxito
                    Navigator.pop(context, true);
                  } catch (e) {
                    print('Error al guardar la categoría: $e');
                    _showErrorDialog(context, 'Hubo un error al guardar la categoría');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
