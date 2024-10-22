// lib/src/presentation/pages/owner/vehicles/vehicle/EditVehiclePage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';

class EditVehiclePage extends StatefulWidget {
  final VehicleModel vehicle;

  const EditVehiclePage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  late String _brand;
  late String _model;
  late String _description;
  late double _price;
  late String _location;
  late String _availability;

  File? _selectedImage; // Archivo de imagen seleccionado

  final ImagePicker _picker = ImagePicker();

  final List<String> _availabilityOptions = [
    'Disponible',
    'No disponible',
    'Bajo mantenimiento'
  ];

  @override
  void initState() {
    super.initState();
    // Inicializa los campos con los datos del vehículo
    _brand = widget.vehicle.brand;
    _model = widget.vehicle.model;
    _description = widget.vehicle.description ?? '';
    _price = widget.vehicle.price;
    _location = widget.vehicle.location;
    _availability = _convertAvailability(widget.vehicle.availability);

    // Si ya hay una imagen, la carga
    if (widget.vehicle.photos != null && widget.vehicle.photos!.isNotEmpty) {
      _selectedImage = File(widget.vehicle.photos!);
    }
  }

  String _convertAvailability(String disponibilidadDb) {
    switch (disponibilidadDb) {
      case 'available':
        return 'Disponible';
      case 'not available':
        return 'No disponible';
      case 'under maintenance':
        return 'Bajo mantenimiento';
      default:
        return 'Disponible'; // Valor por defecto
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

  // Método para guardar los cambios
  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      // Actualiza el vehículo con los nuevos datos
      VehicleModel updatedVehicle = VehicleModel(
        id: widget.vehicle.id,
        ownerId: widget.vehicle.ownerId,
        vehicleTypeId: widget.vehicle.vehicleTypeId,
        brand: _brand,
        model: _model,
        location: _location,
        availability: _availability == 'Disponible'
            ? 'available'
            : (_availability == 'No disponible'
            ? 'not available'
            : 'under maintenance'),
        price: _price,
        photos: _selectedImage != null ? _selectedImage!.path : widget.vehicle.photos,
        description: _description,
      );

      try {
        await VehicleRepository().updateVehicle(updatedVehicle);
        Navigator.pop(context, true); // Devuelve true si se guardó con éxito
      } catch (e) {
        _showErrorDialog(context, 'Hubo un error al actualizar el vehículo');
      }
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
        title: const Text('Editar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Marca
              TextFormField(
                initialValue: _brand,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la marca';
                  }
                  return null;
                },
                onChanged: (value) {
                  _brand = value;
                },
              ),
              const SizedBox(height: 10),
              // Campo de Modelo
              TextFormField(
                initialValue: _model,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el modelo';
                  }
                  return null;
                },
                onChanged: (value) {
                  _model = value;
                },
              ),
              const SizedBox(height: 10),
              // Campo de Ubicación
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                onChanged: (value) {
                  _location = value;
                },
              ),
              const SizedBox(height: 10),
              // Campo de Precio
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  return null;
                },
                onChanged: (value) {
                  _price = double.tryParse(value) ?? 0.0;
                },
              ),
              const SizedBox(height: 10),
              // Campo de Descripción
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                onChanged: (value) {
                  _description = value;
                },
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
                onPressed: _saveVehicle, // Guardar cambios
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color de fondo
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text('Actualizar vehículo', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
