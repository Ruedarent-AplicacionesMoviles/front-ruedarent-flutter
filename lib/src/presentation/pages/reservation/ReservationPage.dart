import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/UserProvider.dart';
import '../../../data/models/reservation_model.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../data/models/vehicle_model.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late final UserProvider _userProvider;
  final ReservationRepository _reservationRepository = ReservationRepository();
  Future<List<ReservationModel>>? _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _reservationsFuture =
        _reservationRepository.getReservationsByUserId(_userProvider.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Reservas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<ReservationModel>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay reservas para mostrar.'));
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return FutureBuilder<VehicleModel?>(
                  future: _fetchVehicleById(reservation.vehicleId),
                  builder: (context, vehicleSnapshot) {
                    if (!vehicleSnapshot.hasData) {
                      return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    final vehicle = vehicleSnapshot.data!;
                    return Dismissible(
                      key: Key(reservation.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteReservation(reservation.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Reserva eliminada: ${reservation.id}')),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reserva ID: ${reservation.id}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              vehicle.photos != null
                                  ? Image.network(vehicle.photos!,
                                  height: 100, fit: BoxFit.cover)
                                  : const Icon(Icons.directions_car,
                                  size: 100, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text('Vehículo: ${vehicle.brand} ${vehicle.model}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Precio: S/. ${vehicle.price.toStringAsFixed(2)}'),
                              Text('Estado: ${reservation.reservationStatus}'),
                              Text('Desde: ${formatDate(reservation.startDate)}'),
                              Text('Hasta: ${formatDate(reservation.endDate)}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _deleteReservation(int id) async {
    await _reservationRepository.deleteReservation(id);
    setState(() {
      _reservationsFuture =
          _reservationRepository.getReservationsByUserId(_userProvider.userId!);
    });
  }

  Future<VehicleModel?> _fetchVehicleById(int vehicleId) async {
    try {
      return await VehicleRepository().getVehicleById(vehicleId);
    } catch (e) {
      print('Error al obtener el vehículo: $e');
      return null;
    }
  }
}
