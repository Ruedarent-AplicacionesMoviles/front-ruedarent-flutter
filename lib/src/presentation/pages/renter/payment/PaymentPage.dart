import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/payment/PaymentConfirmationPage.dart';

class PaymentPage extends StatefulWidget {
  final AddressModel address;

  const PaymentPage({Key? key, required this.address}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();

  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedInstallments;

  final List<String> _months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> _years = List.generate(10, (index) => (DateTime.now().year + index).toString().substring(2));
  final List<String> _installments = ['1 cuota', '2 cuotas', '3 cuotas', '4 cuotas'];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalles del pago',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Dirección de envío: ${widget.address.direccion}, ${widget.address.distrito}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Campo para el número de tarjeta
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el número de tarjeta';
                  } else if (value.length != 16) {
                    return 'El número de tarjeta debe tener 16 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Dropdown para mes y año de expiración
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(labelText: 'Mes de expiración (MM)'),
                      items: _months.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMonth = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona el mes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      decoration: const InputDecoration(labelText: 'Año de expiración (YY)'),
                      items: _years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedYear = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona el año';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Campo para el código de seguridad
              TextFormField(
                controller: _securityCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código de seguridad',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el código de seguridad';
                  } else if (value.length < 3 || value.length > 4) {
                    return 'El código debe tener 3 o 4 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo para el nombre del titular
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del titular',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del titular';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Dropdown para número de cuotas
              DropdownButtonFormField<String>(
                value: _selectedInstallments,
                decoration: const InputDecoration(labelText: 'Número de cuotas'),
                items: _installments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedInstallments = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona el número de cuotas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Botón para confirmar el pago
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Procesamiento del pago (simulación)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando pago...')),
                      );

                      // Simulación del tipo de tarjeta y los últimos 4 dígitos
                      String cardType = 'master';
                      String lastDigits = _cardNumberController.text.substring(_cardNumberController.text.length - 4);

                      // Navegar a la página de confirmación
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentConfirmationPage(
                            cardType: cardType,
                            lastDigits: lastDigits,
                          ),
                        ),
                      );
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