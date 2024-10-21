// lib/src/presentation/pages/owner/vehicles/categories/EditCategoryPage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

class EditCategoryPage extends StatefulWidget {
  final VehicleTypeModel vehicleType; // El tipo de vehículo a editar

  const EditCategoryPage({Key? key, required this.vehicleType}) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  File? _selectedImage; // Archivo de imagen seleccionado

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Cargar los valores iniciales de los controladores
    _nameController.text = widget.vehicleType.name;
    _infoController.text = widget.vehicleType.info ?? '';

    // Si ya hay una imagen, la carga
    if (widget.vehicleType.image != null && widget.vehicleType.image!.isNotEmpty) {
      _selectedImage = File(widget.vehicleType.image!);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _updateCategory() async {
    // Validar que los campos no estén vacíos
    if (_nameController.text.isEmpty ||
        _infoController.text.isEmpty ||
        (_selectedImage == null && widget.vehicleType.image == null)) {
      _showErrorDialog(context, 'Todos los campos son obligatorios');
      return;
    }

    // Crear el mapa de datos para actualizar
    final updatedCategory = {
      'id': widget.vehicleType.id, // Preservar el ID
      'name': _nameController.text,
      'info': _infoController.text,
      'image': _selectedImage != null ? _selectedImage!.path : widget.vehicleType.image,
    };

    try {
      // Actualizar la categoría usando el repositorio
      await VehicleTypeRepository().updateVehicleType(updatedCategory, widget.vehicleType.id!);

      // Volver a la pantalla anterior y actualizar la lista
      Navigator.pop(context, true);
    } catch (e) {
      _showErrorDialog(context, 'Hubo un error al actualizar la categoría');
    }
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
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
              fit: BoxFit.cover,
            )
                : widget.vehicleType.image != null && widget.vehicleType.image!.isNotEmpty
                ? Image.file(
              File(widget.vehicleType.image!),
              height: 200,
              fit: BoxFit.cover,
            )
                : const SizedBox(
              height: 200,
              child: Center(child: Text('No hay imagen seleccionada')),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 16.0),
            // Campo de Nombre
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
            ),
            const SizedBox(height: 10),
            // Campo de Información
            TextField(
              controller: _infoController,
              decoration: const InputDecoration(labelText: 'Información de la categoría'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              child: const Text('Actualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
