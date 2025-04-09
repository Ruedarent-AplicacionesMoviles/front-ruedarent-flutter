import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_ruedarent_flutter/src/data/models/user_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/user_repository.dart';
import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

// ... (importaciones sin cambios)

class _UserProfilePageState extends State<UserProfilePage> {
  UserModel? _user;
  bool _isLoading = true;
  bool _isUpdating = false; // NUEVO estado para bloquear taps durante actualización

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await UserRepository().getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los datos del usuario')),
      );
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    if (_isUpdating) return; // Protege contra taps rápidos
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<UserProvider>(context, listen: false).clearUser();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _isUpdating ? null : () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('Error: User data is null'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text('Nombre: ${_user!.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Correo Electrónico: ${_user!.email}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Tipo de Usuario: ${_user!.userType == 'owner' ? 'Propietario' : 'Rentador'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Preferencias de Notificación: ${_user!.notificationPreferences}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            // Botón Actualizar Perfil
            Center(
              child: ElevatedButton.icon(
                onPressed: _isUpdating
                    ? null
                    : () async {
                  setState(() => _isUpdating = true);
                  final updated = await Navigator.pushNamed(
                    context,
                    '/edit-profile',
                    arguments: _user,
                  );
                  if (updated == true) {
                    await _loadUserProfile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado con éxito')),
                    );
                  }
                  setState(() => _isUpdating = false);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Actualizar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón de Logout adicional
            Center(
              child: ElevatedButton.icon(
                onPressed: _isUpdating ? null : () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
