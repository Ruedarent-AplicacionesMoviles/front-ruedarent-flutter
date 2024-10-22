import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_repository.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/vehicle_type_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/vehicle/VehicleDetailPage.dart';

class CategoryVehiclesForRenterPage extends StatefulWidget {
  final String categoryName;

  const CategoryVehiclesForRenterPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryVehiclesForRenterPageState createState() => _CategoryVehiclesForRenterPageState();
}

class _CategoryVehiclesForRenterPageState extends State<CategoryVehiclesForRenterPage> {
  List<VehicleModel> vehicles = [];
  List<VehicleModel> filteredVehicles = [];
  String searchTerm = ''; // Término de búsqueda

  String? _locationFilter;
  String? _availabilityFilter;
  double? _minPriceFilter;
  double? _maxPriceFilter;

  @override
  void initState() {
    super.initState();
    _loadVehicles(); // Cargar vehículos al iniciar la pantalla
  }

  // Método para cargar vehículos de la categoría
  Future<void> _loadVehicles() async {
    int vehicleTypeId = await _getVehicleTypeIdByName(widget.categoryName);
    if (vehicleTypeId != -1) {
      final data = await VehicleRepository().getAllVehicles();
      setState(() {
        vehicles = data.where((vehicle) => vehicle.vehicleTypeId == vehicleTypeId).toList();
        filteredVehicles = List.from(vehicles); // Inicialmente sin filtros
      });
    }
  }

  // Método para obtener el ID del tipo de vehículo por nombre
  Future<int> _getVehicleTypeIdByName(String name) async {
    final vehicleTypeRepository = VehicleTypeRepository();
    final vehicleType = await vehicleTypeRepository.getVehicleTypeByName(name);
    return vehicleType?.id ?? -1; // Retorna -1 si no se encuentra
  }

  // Mostrar diálogo de filtro
  void _showFilterDialog() {
    TextEditingController locationController = TextEditingController();
    TextEditingController minPriceController = TextEditingController();
    TextEditingController maxPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filtrar Vehículos'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filtro de ubicación
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Ubicación'),
                ),
                const SizedBox(height: 20),

                // Filtro de disponibilidad
                DropdownButtonFormField<String>(
                  value: _availabilityFilter,
                  items: ['available', 'not available', 'under maintenance']
                      .map((status) => DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _availabilityFilter = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Disponibilidad'),
                ),
                const SizedBox(height: 20),

                // Filtro de precio
                TextField(
                  controller: minPriceController,
                  decoration: InputDecoration(labelText: 'Precio Mínimo'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: maxPriceController,
                  decoration: InputDecoration(labelText: 'Precio Máximo'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo sin aplicar filtros
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _locationFilter = locationController.text.isNotEmpty
                      ? locationController.text
                      : null;
                  _minPriceFilter = minPriceController.text.isNotEmpty
                      ? double.tryParse(minPriceController.text)
                      : null;
                  _maxPriceFilter = maxPriceController.text.isNotEmpty
                      ? double.tryParse(maxPriceController.text)
                      : null;
                });
                _applyFilters();
                Navigator.pop(context); // Cerrar diálogo y aplicar filtros
              },
              child: Text('Aplicar Filtro'),
            ),
          ],
        );
      },
    );
  }

  // Método para aplicar filtros
  void _applyFilters() {
    setState(() {
      filteredVehicles = vehicles.where((vehicle) {
        bool matchesLocation = _locationFilter == null ||
            vehicle.location.toLowerCase().contains(_locationFilter!.toLowerCase());
        bool matchesAvailability = _availabilityFilter == null ||
            vehicle.availability == _availabilityFilter;
        bool matchesMinPrice = _minPriceFilter == null ||
            vehicle.price >= _minPriceFilter!;
        bool matchesMaxPrice = _maxPriceFilter == null ||
            vehicle.price <= _maxPriceFilter!;

        return matchesLocation && matchesAvailability && matchesMinPrice && matchesMaxPrice;
      }).toList();
    });
  }

  // Método para aplicar búsqueda
  void _applySearch() {
    setState(() {
      filteredVehicles = vehicles.where((vehicle) {
        return vehicle.brand.toLowerCase().contains(searchTerm.toLowerCase()) ||
            vehicle.model.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos en ${widget.categoryName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Botón de filtro en el AppBar
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog, // Mostrar diálogo de filtro
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por marca o modelo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
                _applySearch(); // Aplicar búsqueda cuando se cambia el término
              },
            ),
            const SizedBox(height: 20),
            // Mostrar resultados filtrados y búsqueda
            Expanded(
              child: filteredVehicles.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredVehicles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Al hacer clic, navega a la página de detalles del vehículo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleDetailPage(
                            vehicle: filteredVehicles[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Imagen del vehículo (URL o asset local si no tiene foto)
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: filteredVehicles[index].photos != null &&
                                  filteredVehicles[index].photos!.isNotEmpty
                                  ? Image.network(filteredVehicles[index].photos!,
                                  fit: BoxFit.cover)
                                  : const Icon(Icons.directions_car,
                                  size: 50, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            // Información del vehículo
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredVehicles[index].brand,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    filteredVehicles[index].model,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'S/. ${filteredVehicles[index].price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.green),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    filteredVehicles[index].location,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text('No hay vehículos disponibles en esta categoría.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}