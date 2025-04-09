import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/vehicle/ConfirmOrderPage.dart';

import 'package:front_ruedarent_flutter/src/data/models/review_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/review_repository.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';

class VehicleDetailPage extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  late Future<List<ReviewModel>> _reviewsFuture;

  final _formKey = GlobalKey<FormState>();
  int? _rating;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewRepository().getReviewsByVehicle(widget.vehicle.id!);
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<UserProvider>().userId;

      try {
        final newReview = ReviewModel(
          vehicleId: widget.vehicle.id!,
          userId: userId!,
          rating: _rating!,
          comment: _commentController.text.trim(),
          timestamp: DateTime.now(),
        );

        await ReviewRepository().insertReview(newReview);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Reseña enviada con éxito!')),
        );

        // Limpiar formulario y recargar reseñas
        _formKey.currentState!.reset();
        _commentController.clear();
        setState(() {
          _reviewsFuture = ReviewRepository().getReviewsByVehicle(widget.vehicle.id!);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar reseña: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;

    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.brand} ${vehicle.model}'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Imagen
            Center(
              child: vehicle.photos != null && vehicle.photos!.isNotEmpty
                  ? Image.network(vehicle.photos!, height: 200, fit: BoxFit.cover)
                  : const Icon(Icons.directions_car, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Detalles
            Text('${vehicle.brand} ${vehicle.model}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Precio: S/. ${vehicle.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.green)),
            Text('Ubicación: ${vehicle.location}', style: const TextStyle(fontSize: 16)),
            Text('Disponibilidad: ${vehicle.availability}', style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
            if (vehicle.description != null && vehicle.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(vehicle.description!, style: const TextStyle(fontSize: 16)),
              ),

            const Divider(height: 32),
            const Text('Reseñas del vehículo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Lista de reseñas
            FutureBuilder<List<ReviewModel>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Este vehículo aún no tiene reseñas.');
                } else {
                  return Column(
                    children: snapshot.data!.map((review) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('⭐️ Calificación: ${review.rating}/5'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (review.comment != null && review.comment!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(review.comment!),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(review.timestamp)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),

            const SizedBox(height: 30),

            const Divider(),
            const Text('Escribir una reseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Formulario de reseña
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Calificación'),
                    value: _rating,
                    items: List.generate(5, (index) => index + 1).map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text('$value estrella${value > 1 ? 's' : ''}'),
                      );
                    }).toList(),
                    onChanged: (value) => _rating = value,
                    validator: (value) => value == null ? 'Selecciona una calificación' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(labelText: 'Comentario (opcional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Enviar Reseña'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Botón alquilar
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmOrderPage(vehicle: vehicle),
                    ),
                  );
                },
                child: const Text('Alquilar Vehículo', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
