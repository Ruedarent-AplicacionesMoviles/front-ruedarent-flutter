import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

class EditCategoryPage extends StatefulWidget {
  final VehicleTypeModel vehicleType;

  const EditCategoryPage({Key? key, required this.vehicleType}) : super(key: key);

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
    _nameController.text = widget.vehicleType.name;
    _infoController.text = widget.vehicleType.info ?? '';
    _imageController.text = widget.vehicleType.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              _imageController.text,
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
              onChanged: (_) => setState(() {}), // Actualiza la imagen al escribir
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateCategory() async {
    if (_nameController.text.isEmpty ||
        _infoController.text.isEmpty ||
        _imageController.text.isEmpty) {
      _showErrorDialog('Todos los campos son obligatorios');
      return;
    }

    final updatedCategory = VehicleTypeModel(
      id: widget.vehicleType.id,
      name: _nameController.text,
      info: _infoController.text,
      image: _imageController.text,
    );

    try {
      await VehicleTypeRepository().updateVehicleType(updatedCategory);
      Navigator.pop(context, true); // Éxito
    } catch (e) {
      print('Error al actualizar categoría: $e');
      _showErrorDialog('Hubo un error al actualizar la categoría');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
