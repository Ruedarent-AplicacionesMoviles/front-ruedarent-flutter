import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/UserProvider.dart';
import '../../../data/models/reservation_model.dart';
import '../../../data/repositories/reservation_repository.dart';

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
    _reservationsFuture = _reservationRepository.getReservationsByUserId(_userProvider.userId);
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay reservas para mostrar.'));
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return Dismissible(
                  key: Key(reservation.id.toString()), // Utiliza el ID de la reserva como clave
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Elimina la reserva
                    _deleteReservation(reservation.id!); // Usa el operador de afirmación aquí
                    // Muestra un snackbar de confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reserva eliminada: ${reservation.id}')),
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
                              Icon(Icons.calendar_today, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Reserva ID: ${reservation.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('Vehículo ID: ${reservation.vehicleId}', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Text('Estado: ${reservation.reservationStatus}', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Text('Desde: ${formatDate(reservation.startDate)}', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Text('Hasta: ${formatDate(reservation.endDate)}', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _deleteReservation(int id) async {
    await _reservationRepository.deleteReservation(id);
    setState(() {
      _reservationsFuture = _reservationRepository.getReservationsByUserId(_userProvider.userId);
    });
  }
}
