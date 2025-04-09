import 'package:flutter/material.dart';
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
  late String _description;
  late double _price;
  late String _location;
  String _availability = 'Disponible';

  final List<String> _availabilityOptions = [
    'Disponible',
    'No disponible',
    'Bajo mantenimiento'
  ];

  @override
  void initState() {
    super.initState();
    _brand = widget.vehicle.brand;
    _description = widget.vehicle.description ?? '';
    _price = widget.vehicle.price;
    _location = widget.vehicle.location;
    _availability = _convertAvailability(widget.vehicle.availability);
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
        return 'Disponible';
    }
  }

  String _convertToDbAvailability(String disponibilidadUi) {
    switch (disponibilidadUi) {
      case 'Disponible':
        return 'available';
      case 'No disponible':
        return 'not available';
      case 'Bajo mantenimiento':
        return 'under maintenance';
      default:
        return 'available';
    }
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final updatedVehicle = VehicleModel(
        id: widget.vehicle.id,
        ownerId: widget.vehicle.ownerId,
        vehicleTypeId: widget.vehicle.vehicleTypeId,
        brand: _brand,
        model: widget.vehicle.model,
        location: _location,
        availability: _convertToDbAvailability(_availability),
        price: _price,
        photos: widget.vehicle.photos,
        description: _description,
      );

      try {
        final success = await VehicleRepository().updateVehicle(updatedVehicle);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehículo actualizado correctamente')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        print('Error al actualizar vehículo: $e');
        _showErrorDialog('No se pudo actualizar el vehículo. Intenta nuevamente.');
      }
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Vehículo'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _brand,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa la marca'
                    : null,
                onChanged: (value) => _brand = value,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) => _description = value,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor ingresa el precio' : null,
                onChanged: (value) => _price = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                onChanged: (value) => _location = value,
              ),
              DropdownButtonFormField<String>(
                value: _availability,
                decoration: const InputDecoration(labelText: 'Disponibilidad'),
                items: _availabilityOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _availability = newValue);
                  }
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona una disponibilidad' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text(
                  'Actualizar vehículo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
