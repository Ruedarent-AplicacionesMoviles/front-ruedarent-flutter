import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/reservation_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/reservation_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/payment/PaymentConfirmationPage.dart';

class PaymentPage extends StatefulWidget {
  final AddressModel address;
  final VehicleModel vehicle;

  const PaymentPage({Key? key, required this.address, required this.vehicle}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final ReservationRepository _reservationRepository = ReservationRepository();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();

  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedInstallments;

  final List<String> _months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> _years = List.generate(10, (index) => (DateTime.now().year + index).toString().substring(2));
  final List<String> _installments = ['1 cuota', '2 cuotas', '3 cuotas', '4 cuotas'];

  Future<void> _processPayment() async {
    final userProvider = context.read<UserProvider>();

    ReservationModel reservation = ReservationModel(
      renterId: userProvider.userId!,
      vehicleId: widget.vehicle.id!,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      pickupLocation: widget.address.direccion,
      dropoffLocation: widget.address.direccion,
      reservationStatus: 'confirmed',
      totalPrice: widget.vehicle.price,
      paymentMethod: 'card',
    );

    try {
      await _reservationRepository.createReservation(reservation);

      String cardType = 'master';
      String lastDigits = _cardNumberController.text.substring(_cardNumberController.text.length - 4);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationPage(
            cardType: cardType,
            lastDigits: lastDigits,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar el pago: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de pago'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Detalles del pago', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Dirección: ${widget.address.direccion}, ${widget.address.distrito}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Número de tarjeta'),
                keyboardType: TextInputType.number,
                maxLength: 16,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value == null || value.length != 16 ? 'Debe tener 16 dígitos' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(labelText: 'Mes (MM)'),
                      items: _months.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                      onChanged: (val) => setState(() => _selectedMonth = val),
                      validator: (val) => val == null ? 'Selecciona mes' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      decoration: const InputDecoration(labelText: 'Año (YY)'),
                      items: _years.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                      onChanged: (val) => setState(() => _selectedYear = val),
                      validator: (val) => val == null ? 'Selecciona año' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _securityCodeController,
                decoration: const InputDecoration(labelText: 'Código de seguridad'),
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value == null || value.length < 3 ? 'Código inválido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(labelText: 'Nombre del titular'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedInstallments,
                decoration: const InputDecoration(labelText: 'Cuotas'),
                items: _installments.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                onChanged: (val) => setState(() => _selectedInstallments = val),
                validator: (val) => val == null ? 'Selecciona cuotas' : null,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _processPayment();
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
