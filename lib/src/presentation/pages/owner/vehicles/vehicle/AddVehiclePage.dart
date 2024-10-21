// lib/src/presentation/pages/owner/vehicles/vehicle/AddVehiclePage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';

class AddVehiclePage extends StatefulWidget {
  final int vehicleTypeId; // ID del tipo de vehículo que se pasa al constructor

  const AddVehiclePage({Key? key, required this.vehicleTypeId}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  Future<void> _saveVehicle() async {
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
      vehicleTypeId: widget.vehicleTypeId,
      brand: _brandController.text,
      model: _modelController.text,
      location: _locationController.text,
      availability: 'available', // Valor predeterminado
      price: double.parse(_priceController.text),
      photos: _selectedImage != null ? _selectedImage!.path : null, // Guardar la ruta de la imagen
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
        title: const Text('Agregar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de Marca
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 10),
              // Campo de Modelo
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 10),
              // Campo de Ubicación
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              const SizedBox(height: 10),
              // Campo de Precio
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Campo de Descripción
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
              ),
              const SizedBox(height: 20),
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
                onPressed: _saveVehicle,
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
