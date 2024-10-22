import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/filter/FilteredVehiclePage.dart';

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

  // Lista de distritos de Lima, Perú
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
            const Text(
              'Disponibilidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedAvailability,
              hint: const Text('Seleccionar disponibilidad'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAvailability = newValue;
                });
              },
              items: <String>['available', 'not available', 'under maintenance']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ubicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedLocation,
              hint: const Text('Seleccionar ubicación'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: _locations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Rango de Precio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 150,
              divisions: 30, // Divisiones para que sean de 5 en 5
              labels: RangeLabels(
                _priceRange.start.round().toString(),
                _priceRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                if (values.start >= 0 && values.end <= 150) {
                  setState(() {
                    _priceRange = values;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de resultados con los filtros aplicados
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredVehiclesPage(
                      availability: _selectedAvailability,
                      location: _selectedLocation,
                      priceRange: _priceRange,
                    ),
                  ),
                );
              },
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }
}