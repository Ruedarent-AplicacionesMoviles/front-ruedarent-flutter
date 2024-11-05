import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class RolesPage extends StatelessWidget {
  final UserModel user;
  final UserRepository _userRepository = UserRepository();

  RolesPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
    final int? userId = user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un rol'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Selecciona un rol',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildRoleOption(
                context,
                imagePath: 'assets/images/roles/propietario.jpg',
                label: 'Propietario',
                onTap: () async {
                  await _userRepository.updateUserRole(userId!, 'owner');
                  Navigator.pushNamed(context, '/vehicles-owner');
                  print("Propietario seleccionado");
                },
              ),
              const SizedBox(height: 20),
              _buildRoleOption(
                context,
                imagePath: 'assets/images/roles/rentador.jpg',
                label: 'Rentador',
                onTap: () async {
                  await _userRepository.updateUserRole(userId!, 'renter');
                  Navigator.pushNamed(context, '/vehicles-renter', arguments: userId);
                  print("Rentador seleccionado");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(BuildContext context, {required String imagePath, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}