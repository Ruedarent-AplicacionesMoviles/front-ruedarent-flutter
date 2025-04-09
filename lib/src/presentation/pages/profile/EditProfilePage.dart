import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/data/models/user_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/user_repository.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedUserType = 'owner';
  String _notificationPreferences = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedUserType = widget.user.userType;
    _notificationPreferences = widget.user.notificationPreferences;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserModel updatedUser = UserModel(
        id: widget.user.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: widget.user.password, // mantenemos la misma contraseña
        userType: _selectedUserType,
        notificationPreferences: _notificationPreferences,
      );

      await UserRepository().updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
      Navigator.pop(context, true); // Indicamos que se actualizó
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@')
                    ? 'Correo inválido'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                items: const [
                  DropdownMenuItem(value: 'owner', child: Text('Propietario')),
                  DropdownMenuItem(value: 'renter', child: Text('Rentador')),
                ],
                onChanged: (value) => setState(() => _selectedUserType = value!),
                decoration: const InputDecoration(labelText: 'Tipo de usuario'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _notificationPreferences == 'all',
                title: const Text('Recibir todas las notificaciones'),
                onChanged: (value) {
                  setState(() {
                    _notificationPreferences = value ? 'all' : 'none';
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
