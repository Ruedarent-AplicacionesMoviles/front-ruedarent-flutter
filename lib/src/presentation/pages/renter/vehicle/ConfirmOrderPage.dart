import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/reservation_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddressSelectionPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/payment/PaymentPage.dart';

import 'package:front_ruedarent_flutter/src/data/models/notification_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/notification_repository.dart';

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
  final VehicleRepository _vehicleRepository = VehicleRepository();
  final ReservationRepository _reservationRepository = ReservationRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  Future<void> _createReservation(int userId) async {
    try {
      ReservationModel reservation = ReservationModel(
        renterId: userId,
        vehicleId: widget.vehicle.id!,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        pickupLocation: 'a',
        dropoffLocation: 'b',
        reservationStatus: 'confirmed',
        totalPrice: widget.vehicle.price,
        paymentMethod: 'cash',
      );

      await _reservationRepository.createReservation(reservation);
      await _createNotification(widget.vehicle.ownerId, widget.vehicle.id!);
    } catch (e) {
      print('Error al crear la reserva: $e');
    }
  }

  Future<void> _createNotification(int ownerId, int vehicleId) async {
    final NotificationModel notification = NotificationModel(
      userId: ownerId,
      notificationType: 'Nueva reserva',
      content: 'Tu vehículo con ID $vehicleId ha sido reservado.',
      timestamp: DateTime.now(),
      read: false,
    );

    try {
      await _notificationRepository.insertNotification(notification);
    } catch (e) {
      print('Error al crear notificación: $e');
    }
  }

  Future<void> _setVehicleNotAvailable() async {
    if (widget.vehicle.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID del vehículo no disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _vehicleRepository.updateVehicleAvailability(widget.vehicle.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehículo reservado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
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
    final AddressModel? address = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressSelectionPage(
          userId: _userProvider.userId!,
          vehicle: widget.vehicle,
        ),
      ),
    );

    if (address != null) {
      setState(() {
        selectedAddress = address;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            address: address,
            vehicle: widget.vehicle,
          ),
        ),
      );
    }
  }

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
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isVehicleDeleted = true;
                });
                Navigator.of(context).pop();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
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
                    onPressed: _confirmDeleteVehicle,
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
            if (selectedAddress != null)
              Card(
                child: ListTile(
                  title: Text(selectedAddress!.direccion),
                  subtitle: Text(selectedAddress!.distrito),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _selectAddress,
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _selectAddress,
                icon: const Icon(Icons.location_on),
                label: const Text('Seleccionar Dirección de Envío'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            const SizedBox(height: 20),
            if (!isVehicleDeleted) ...[
              const Text(
                'Total a pagar:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'S/. ${widget.vehicle.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
            const Spacer(),
            if (isVehicleDeleted)
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text(
                      '¿Deseas agregar un nuevo vehículo?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
