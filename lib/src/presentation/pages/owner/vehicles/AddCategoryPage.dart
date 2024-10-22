// lib/src/presentation/pages/owner/vehicles/categories/AddCategoryPage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';

class AddCategoryPage extends StatefulWidget {
  AddCategoryPage({super.key});

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  File? _selectedImage; // Archivo de imagen seleccionado

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveCategory() async {
    // Validar que los campos no estén vacíos
    if (_nameController.text.isEmpty ||
        _infoController.text.isEmpty ||
        _selectedImage == null) {
      _showErrorDialog(context, 'Todos los campos son obligatorios');
      return;
    }

    // Crear una instancia de VehicleTypeModel
    final newCategory = VehicleTypeModel(
      name: _nameController.text,
      info: _infoController.text,
      image: _selectedImage!.path, // Guardar la ruta de la imagen
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
        title: const Text('Agregar Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite el desplazamiento si el contenido es largo
          child: Column(
            children: [
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
              const SizedBox(height: 10),
              // Selección de Imagen
              Row(
                children: [
                  _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image, size: 100, color: Colors.grey),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Seleccionar Imagen'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
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
}
