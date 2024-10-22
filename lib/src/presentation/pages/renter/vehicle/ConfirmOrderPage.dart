import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart'; // Importar la página de categorías
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddressSelectionPage.dart';

class ConfirmOrderPage extends StatefulWidget {
  final VehicleModel vehicle; // Recibe el vehículo seleccionado

  const ConfirmOrderPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  AddressModel? selectedAddress; // Dirección seleccionada para la orden
  bool isVehicleDeleted = false; // Variable para rastrear si el vehículo ha sido eliminado

  // Navegar a la página de selección de direcciones
  Future<void> _selectAddress() async {
    final AddressModel? address = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressSelectionPage(userId: 1), // Asumimos un userId fijo (puedes ajustarlo)
      ),
    );

    if (address != null) {
      setState(() {
        selectedAddress = address; // Actualizar la dirección seleccionada
      });
    }
  }

  // Mostrar un diálogo de confirmación antes de eliminar el vehículo
  Future<void> _confirmDeleteVehicle() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Vehículo'),
          content: const Text('¿Estás seguro de que deseas eliminar este vehículo de tu orden?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isVehicleDeleted = true; // Marcar el vehículo como eliminado
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Eliminar'),
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
        title: const Text('Confirmar Orden'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centrar el contenido horizontalmente
          children: [
            const SizedBox(height: 40), // Espaciado en la parte superior
            // Mostrar detalles del vehículo con botón de eliminar, solo si no ha sido eliminado
            if (!isVehicleDeleted)
              Card(
                child: ListTile(
                  title: Text('${widget.vehicle.brand} ${widget.vehicle.model}'),
                  subtitle: Text('S/. ${widget.vehicle.price.toStringAsFixed(2)} - ${widget.vehicle.location}'),
                  leading: widget.vehicle.photos != null && widget.vehicle.photos!.isNotEmpty
                      ? Image.network(widget.vehicle.photos!, height: 50, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.directions_car, size: 50),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _confirmDeleteVehicle, // Mostrar advertencia antes de eliminar el vehículo
                  ),
                ),
              ),
            if (isVehicleDeleted)
              const Center(
                child: Text(
                  'Vehículo eliminado de la orden',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            // Mostrar la dirección seleccionada o permitir seleccionar una dirección
            if (selectedAddress != null)
              Card(
                child: ListTile(
                  title: Text(selectedAddress!.direccion),
                  subtitle: Text(selectedAddress!.distrito),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _selectAddress, // Permitir editar la dirección seleccionada
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _selectAddress, // Seleccionar dirección si aún no lo ha hecho
                icon: const Icon(Icons.location_on),
                label: const Text('Seleccionar Dirección de Envío'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            const SizedBox(height: 20),
            // Resumen de la orden (por ejemplo, el total a pagar), solo si el vehículo no ha sido eliminado
            if (!isVehicleDeleted) ...[
              const Text(
                'Total a pagar:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'S/. ${widget.vehicle.price.toStringAsFixed(2)}', // Mostrar el precio del vehículo
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
            const Spacer(), // Empuja el contenido de abajo hacia el centro
            // Si el vehículo ha sido eliminado, mostrar una opción para agregar un nuevo vehículo
            if (isVehicleDeleted)
              Align(
                alignment: Alignment.center, // Centrar el botón de agregar vehículo
                child: Column(
                  children: [
                    const Text(
                      '¿Deseas agregar un nuevo vehículo?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Redirigir a la página de categorías para seleccionar un nuevo vehículo
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RentadorVehiclesPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Agregar Vehículo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 40), // Espaciado en la parte inferior
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}