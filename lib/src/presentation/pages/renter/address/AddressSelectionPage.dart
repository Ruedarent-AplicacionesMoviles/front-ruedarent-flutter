import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/address_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/address_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddNewAddressPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/payment/PaymentPage.dart'; // Asegúrate de tener esta página

class AddressSelectionPage extends StatefulWidget {
  final int userId; // Recibe el userId del usuario

  const AddressSelectionPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddressSelectionPageState createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  List<AddressModel> addresses = []; // Lista de direcciones para el usuario
  int? _selectedAddressIndex; // Índice de la dirección seleccionada

  @override
  void initState() {
    super.initState();
    _loadAddresses(); // Cargar las direcciones desde la base de datos
  }

  // Método para cargar las direcciones desde la base de datos
  void _loadAddresses() async {
    List<AddressModel> data = await AddressRepository().getAllAddresses(widget.userId);
    setState(() {
      addresses = data; // Actualizar el estado con las direcciones cargadas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis direcciones'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: addresses.isNotEmpty
                  ? ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: Text(addresses[index].direccion),
                      subtitle: Text(addresses[index].distrito),
                      leading: Icon(
                        _selectedAddressIndex == index
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.green,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(addresses[index], index);
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedAddressIndex = index; // Seleccionar la dirección
                        });
                      },
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No tienes ninguna dirección registrada.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botón "Confirmar Orden" si se ha seleccionado una dirección
            if (_selectedAddressIndex != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(address: addresses[_selectedAddressIndex!]),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Confirmar Orden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            const SizedBox(height: 10), // Separador entre botones
            ElevatedButton.icon(
              onPressed: () async {
                final newAddress = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewAddressPage(userId: widget.userId), // Navegar a la pantalla de agregar dirección
                  ),
                );

                if (newAddress != null) {
                  setState(() {
                    addresses.add(newAddress); // Agregar la nueva dirección y actualizar la UI
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar nueva dirección'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20), // Separador adicional
          ],
        ),
      ),
    );
  }

  // Método para mostrar una alerta de confirmación antes de eliminar
  void _showDeleteConfirmationDialog(AddressModel address, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar dirección'),
          content: const Text('¿Estás seguro de que deseas eliminar esta dirección?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await AddressRepository().deleteAddress(address.id!); // Eliminar de la base de datos
                setState(() {
                  addresses.removeAt(index); // Actualizar la lista en la UI
                });
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}