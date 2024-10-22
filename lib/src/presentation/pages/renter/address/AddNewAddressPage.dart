import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/address_repository.dart';


class AddNewAddressPage extends StatefulWidget {
  final int userId; // Recibe el userId para asociarlo a la nueva dirección

  const AddNewAddressPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  bool _isSaving = false; // Variable para controlar el estado de guardado

  // Método para crear una nueva dirección
  Future<void> _createAddress() async {
    if (_addressController.text.isNotEmpty && _districtController.text.isNotEmpty) {
      setState(() {
        _isSaving = true; // Mostrar que estamos guardando
      });

      try {
        // Crear el modelo AddressModel con los datos del usuario
        final newAddress = AddressModel(
          direccion: _addressController.text,
          distrito: _districtController.text,
          userId: widget.userId, // Asociar la dirección al userId
        );

        // Insertar la nueva dirección en la base de datos
        int insertedId = await AddressRepository().insertAddress(newAddress);

        if (insertedId > 0) {
          newAddress.id = insertedId; // Asignar el ID devuelto por la BD
          Navigator.pop(context, newAddress); // Volver a "Mis Direcciones" pasando la nueva dirección
        } else {
          // Mostrar un error si la inserción falla
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear la dirección. Inténtalo nuevamente.')),
          );
        }
      } catch (error) {
        // Mostrar un mensaje de error si la operación falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        setState(() {
          _isSaving = false; // Ocultar el estado de guardado
        });
      }
    } else {
      // Mostrar mensaje de error si los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva dirección'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.location_on, size: 150, color: Colors.green),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                prefixIcon: const Icon(Icons.location_on, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(
                labelText: 'Distrito',
                prefixIcon: const Icon(Icons.map, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _createAddress, // Deshabilitar el botón si está guardando
                icon: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.check),
                label: Text(_isSaving ? 'Guardando...' : 'Crear dirección'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}