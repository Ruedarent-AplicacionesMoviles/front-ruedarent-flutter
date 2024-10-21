import 'package:flutter/material.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rol'),
        backgroundColor: Colors.green, // Color del AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Envolvemos en un scroll por si el contenido es largo
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Alinea los elementos hacia arriba
              crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Selecciona un rol',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Propietario Role
                _buildRoleOption(
                  context,
                  imagePath: 'assets/images/roles/propietario.jpg', // Cambia esto por la imagen correcta
                  label: 'Propietario',
                  onTap: () {
                    print("Propietario seleccionado");
                  },
                ),
                const SizedBox(height: 20), // Reducimos el espacio entre roles
                // Rentador Role
                _buildRoleOption(
                  context,
                  imagePath: 'assets/images/roles/rentador.jpg', // Cambia esto por la imagen correcta
                  label: 'Rentador',
                  onTap: () {
                    print("Rentador seleccionado");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para cada opción de rol
  Widget _buildRoleOption(BuildContext context, {required String imagePath, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 80, // Ajuste del tamaño de la imagen circular
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 150, // Ajuste del tamaño del botón
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Color del botón verde como en el Figma
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Borde redondeado
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0), // Espaciado interno del botón
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18, // Tamaño de letra mayor
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}