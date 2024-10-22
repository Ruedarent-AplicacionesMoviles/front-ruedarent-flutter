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
  String _availability = 'Disponible'; // Valor por defecto

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
    _description = widget.vehicle.description ?? '';
    _price = widget.vehicle.price;
    _location = widget.vehicle.location;
    _availability = _convertAvailability(widget.vehicle.availability); // Convertir al valor correspondiente
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

  // Método para guardar los cambios
  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      // Actualiza el vehículo con los nuevos datos
      VehicleModel updatedVehicle = VehicleModel(
        id: widget.vehicle.id,
        ownerId: widget.vehicle.ownerId,
        vehicleTypeId: widget.vehicle.vehicleTypeId,
        brand: _brand,
        description: _description,
        price: _price,
        location: _location,
        availability: _availability == 'Disponible'
            ? 'available'
            : (_availability == 'No disponible'
            ? 'not available'
            : 'under maintenance'),
        photos: widget.vehicle.photos,
        model: widget.vehicle.model, // Asegúrate de incluir el modelo también
      );

      await VehicleRepository().updateVehicle(updatedVehicle);
      Navigator.pop(context, true); // Devuelve true si se guardó con éxito
    }
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
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  _description = value;
                },
              ),
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
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                onChanged: (value) {
                  _location = value;
                },
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
                  setState(() {
                    _availability = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una disponibilidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVehicle, // Guardar cambios
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300, // Color de fondo
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
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

