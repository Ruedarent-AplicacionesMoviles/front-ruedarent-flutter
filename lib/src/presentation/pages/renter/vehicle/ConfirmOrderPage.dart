import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddressSelectionPage.dart';


class ConfirmOrderPage extends StatefulWidget {
  final VehicleModel vehicle; // Recibe el vehículo seleccionado

  const ConfirmOrderPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  AddressModel? selectedAddress; // Dirección seleccionada para la orden

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar detalles del vehículo
            Card(
              child: ListTile(
                title: Text('${widget.vehicle.brand} ${widget.vehicle.model}'),
                subtitle: Text('S/. ${widget.vehicle.price.toStringAsFixed(2)} - ${widget.vehicle.location}'),
                leading: widget.vehicle.photos != null && widget.vehicle.photos!.isNotEmpty
                    ? Image.network(widget.vehicle.photos!, height: 50, width: 50, fit: BoxFit.cover)
                    : const Icon(Icons.directions_car, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            // Mostrar la dirección seleccionada
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
            // Resumen de la orden (por ejemplo, el total a pagar)
            const Text(
              'Total a pagar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'S/. ${widget.vehicle.price.toStringAsFixed(2)}', // Mostrar el precio del vehículo
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                if (selectedAddress != null) {
                  // Lógica para confirmar la orden con la dirección seleccionada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Orden confirmada con la dirección: ${selectedAddress!.direccion}')),
                  );
                  // Aquí podrías redirigir al usuario a otra pantalla o finalizar el proceso
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, selecciona una dirección')),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Confirmar Orden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}