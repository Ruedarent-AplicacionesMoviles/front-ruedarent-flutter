import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/database_helper.dart';

class EditCategoryPage extends StatelessWidget {
  final Map<String, dynamic> category;

  EditCategoryPage({required this.category});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    _nameController.text = category['name'];
    _infoController.text = category['info'];
    _imageController.text = category['image'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la categoría'),
            ),
            TextField(
              controller: _infoController,
              decoration: InputDecoration(labelText: 'Información de la categoría'),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Ruta de la imagen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedCategory = {
                  'name': _nameController.text,
                  'info': _infoController.text,
                  'image': _imageController.text
                };
                await DatabaseHelper().updateVehicle(updatedCategory, category['id']);
                Navigator.pop(context);  // Volver a la pantalla anterior después de guardar
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}