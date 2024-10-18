import 'package:flutter/material.dart';

class DefaultTextfield extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final Function(String)? onChanged;
  final String? errorText;  // Añadimos el parámetro nullable para manejar errores

  const DefaultTextfield({
    Key? key,
    required this.label,
    required this.icon,
    this.onChanged,
    this.isPassword = false,
    this.errorText,  // Inicializamos el parámetro errorText como opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: const OutlineInputBorder(),
        errorText: errorText,  // Aquí mostramos el mensaje de error si existe
      ),
    );
  }
}