import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/vehicle/VehicleDetailPage.dart';

class FilteredVehiclesPage extends StatefulWidget {
  final String? availability;
  final String? location;
  final RangeValues priceRange;

  const FilteredVehiclesPage({
    Key? key,
    this.availability,
    this.location,
    required this.priceRange,
  }) : super(key: key);

  @override
  _FilteredVehiclesPageState createState() => _FilteredVehiclesPageState();
}

class _FilteredVehiclesPageState extends State<FilteredVehiclesPage> {
  final VehicleRepository _vehicleRepository = VehicleRepository();
  List<VehicleModel> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadFilteredVehicles(); // Cargar los vehículos filtrados al iniciar
  }

  // Método para cargar los vehículos filtrados desde SQLite
  Future<void> _loadFilteredVehicles() async {
    final vehicles = await _vehicleRepository.searchVehicles(
      location: widget.location,
      minPrice: widget.priceRange.start,
      maxPrice: widget.priceRange.end,
      availability: widget.availability,
    );
    setState(() {
      _filteredVehicles = vehicles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Filtrados'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card para mostrar los filtros aplicados
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filtros Aplicados:', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (widget.availability != null)
                      Text('Disponibilidad: ${widget.availability}'),
                    if (widget.location != null)
                      Text('Ubicación: ${widget.location}'),
                    Text('Rango de Precio: ${widget.priceRange.start} - ${widget.priceRange.end}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de vehículos filtrados
            Expanded(
              child: _filteredVehicles.isNotEmpty
                  ? ListView.builder(
                itemCount: _filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _filteredVehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: vehicle.photos != null
                          ? Image.network(vehicle.photos!, width: 50, height: 50)
                          : const Icon(Icons.directions_car),
                      title: Text('${vehicle.brand} ${vehicle.model}'),
                      subtitle: Text('Precio: S/.${vehicle.price.toStringAsFixed(2)}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navegar a la página de detalles del vehículo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailPage(vehicle: vehicle),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No se encontraron vehículos con los filtros aplicados.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}