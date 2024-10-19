import 'package:flutter/material.dart';

class BikeCategoryPage extends StatefulWidget {
  @override
  _BikeCategoryPageState createState() => _BikeCategoryPageState();
}

class _BikeCategoryPageState extends State<BikeCategoryPage> {
  List<Map<String, String>> bicycles = [
    {
      'name': 'Max E.',
      'info': 'Scooter Eléctrico',
      'price': 'S/. 20',
      'location': 'Lima, Peru',
    },
    {
      'name': 'Max E.',
      'info': 'Scooter Eléctrico',
      'price': 'S/. 20',
      'location': 'Lima, Peru',
    },
    {
      'name': 'Max E.',
      'info': 'Scooter Eléctrico',
      'price': 'S/. 20',
      'location': 'Lima, Peru',
    },
  ];

  // Método para mostrar el cuadro de diálogo de confirmación de eliminación
  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();  // Cerrar el cuadro de diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() {
                  bicycles.removeAt(index);  // Eliminar la categoría de la lista
                });
                Navigator.of(context).pop();  // Cerrar el cuadro de diálogo después de eliminar
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categoria Bicicleta'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categoria Bicicleta',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bicycles.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.blue.shade100, // Imagen simulada
                      ),
                      title: Text(bicycles[index]['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bicycles[index]['info']!),
                          Text(
                            bicycles[index]['price']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(bicycles[index]['location']!),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.green),
                            onPressed: () {
                              // Mostrar el cuadro de diálogo de eliminación
                              _showDeleteDialog(context, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              // Lógica para editar
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para agregar un vehículo
                  Navigator.pushNamed(context, '/add-vehicle');
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text('Agregar vehículo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}