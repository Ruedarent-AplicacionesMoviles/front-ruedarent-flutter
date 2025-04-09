import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  final String? selectedAvailability;
  final String? selectedLocation;
  final RangeValues priceRange;

  const FiltersPage({
    Key? key,
    this.selectedAvailability,
    this.selectedLocation,
    required this.priceRange,
  }) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  String? _selectedAvailability;
  String? _selectedLocation;
  RangeValues _priceRange = const RangeValues(0, 150);

  final List<String> _locations = [
    'San Isidro', 'Miraflores', 'La Molina', 'Surco', 'San Borja', 'Lince',
    'Barranco', 'San Miguel', 'Magdalena', 'Pueblo Libre', 'Jesus María',
    'Breña', 'Rímac', 'San Juan de Lurigancho', 'Villa María del Triunfo',
    'Villa El Salvador', 'Callao', 'Santa Anita', 'Ate', 'Cercado de Lima'
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.priceRange.start < 0 ? 0 : widget.priceRange.start,
      widget.priceRange.end > 150 ? 150 : widget.priceRange.end,
    );
    _selectedAvailability = widget.selectedAvailability;
    _selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicar Filtros'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Disponibilidad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedAvailability,
              hint: const Text('Seleccionar disponibilidad'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAvailability = newValue;
                });
              },
              items: <String>['available', 'not available', 'under maintenance']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text('Ubicación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLocation,
              hint: const Text('Seleccionar ubicación'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: _locations.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Rango de Precio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  RangeSlider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.shade100,
                    values: _priceRange,
                    min: 0,
                    max: 150,
                    divisions: 30,
                    labels: RangeLabels(
                      _priceRange.start.round().toString(),
                      _priceRange.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('S/${_priceRange.start.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                      Text('S/${_priceRange.end.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'availability': _selectedAvailability,
                  'location': _selectedLocation,
                  'priceRange': _priceRange,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
