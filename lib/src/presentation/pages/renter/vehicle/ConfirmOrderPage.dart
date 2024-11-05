import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/reservation_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart'; // Añadir esta importación
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddressSelectionPage.dart';

import '../../../../data/UserProvider.dart';
import '../../../../data/models/reservation_model.dart';

class ConfirmOrderPage extends StatefulWidget {
  final VehicleModel vehicle;

  const ConfirmOrderPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  AddressModel? selectedAddress;
  bool isVehicleDeleted = false;
  final VehicleRepository _vehicleRepository = VehicleRepository();// Añadir esta línea
  final ReservationRepository _reservationRepository = ReservationRepository();
  late final UserProvider _userProvider;




  @override
  void initState() {
    super.initState();
    // Imprimir detalles del vehículo al iniciar
    print('Iniciando ConfirmOrderPage');
    print('ID del vehículo: ${widget.vehicle.id}');
    print('Marca: ${widget.vehicle.brand}');
    print('Modelo: ${widget.vehicle.model}');
    _userProvider = context.read<UserProvider>();
  }

  Future<void> _createReservation(int userId) async {
    try {
      // Crear la reserva con los datos relevantes
      // Imprimir los valores que se usarán para crear la reserva
      print('Creando reserva con los siguientes valores:');
      print('Renter ID: $userId');
      print('Vehicle ID: ${widget.vehicle.id}');
      print('Start Date: ${DateTime.now()}');
      print('End Date: ${DateTime.now().add(const Duration(days: 7))}');
      print('Pickup Location: a');
      print('Dropoff Location: b');
      print('Reservation Status: pending');
      print('Total Price: ${widget.vehicle.price}');
      print('Payment Method: cash');
      ReservationModel reservation = ReservationModel(
        renterId: userId,
        vehicleId: widget.vehicle.id!,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)), // Ejemplo, debes obtener las fechas de la interfaz
        pickupLocation: 'a',
        dropoffLocation: 'b',
        reservationStatus: 'confirmed',
        totalPrice: widget.vehicle.price,
        paymentMethod: 'cash', // Ejemplo, debes obtener el método de pago de la interfaz
      );

      // Guardar la reserva en la base de datos o enviar a un servicio
      await _reservationRepository.insertReservation(reservation);
    } catch (e) {
      // Manejar el error de creación de la reserva
      print('Error al crear la reserva: $e');
    }
  }


  // Método para actualizar la disponibilidad del vehículo
  Future<void> _setVehicleNotAvailable() async {
    print('Intentando actualizar disponibilidad del vehículo');
    print('ID del vehículo a actualizar: ${widget.vehicle.id}');

    if (widget.vehicle.id == null) {
      print('Error: ID del vehículo es null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID del vehículo no disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print('Llamando a updateVehicleAvailability');
      final result = await _vehicleRepository.updateVehicleAvailability(widget.vehicle.id!);
      print('Resultado de la actualización: $result');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehículo reservado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error al actualizar disponibilidad: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la disponibilidad: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectAddress() async {
    print('Iniciando selección de dirección');
    print('Llamando a _setVehicleNotAvailable');
    await _setVehicleNotAvailable();

    print('Actualizando estado con nueva dirección');

    await _createReservation(_userProvider.userId);

    final AddressModel? address = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressSelectionPage(userId: _userProvider.userId),
      ),
    );

    print('Dirección seleccionada: ${address?.direccion}');

    if (address != null) {


      setState(() {
        selectedAddress = address;
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