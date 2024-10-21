import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

class EditCategoryPage extends StatefulWidget {
  final VehicleTypeModel vehicleType; // El vehículo a editar

  EditCategoryPage({Key? key, required this.vehicleType}) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar los valores iniciales de los controladores
    _nameController.text = widget.vehicleType.name; // Cargar el nombre
    _infoController.text = widget.vehicleType.info!; // Cargar la info
    _imageController.text = widget.vehicleType.image!; // Cargar la imagen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar la imagen en la parte superior
            Image.network(
              widget.vehicleType.image!,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text('Error al cargar la imagen')),
                );
              },
            ),
            const SizedBox(height: 16.0),
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

                // Crear el mapa de datos para actualizar
                final updatedCategory = {
                  'id': widget.vehicleType.id, // Preservar el ID
                  'name': _nameController.text,
                  'info': _infoController.text,
                  'image': _imageController.text,
                };

                try {
                  // Actualizar la categoría usando el repositorio
                  await VehicleTypeRepository().updateVehicleType(updatedCategory, widget.vehicleType.id!);

                  // Volver a la pantalla anterior y actualizar la lista
                  Navigator.pop(context, true);
                } catch (e) {
                  _showErrorDialog(context, 'Hubo un error al actualizar la categoría');
                }
              },
              child: const Text('Actualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
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