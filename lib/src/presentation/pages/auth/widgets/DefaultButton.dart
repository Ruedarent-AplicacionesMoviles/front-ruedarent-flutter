import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;  // Función que se ejecuta cuando se presiona el botón
  final String text;  // Texto del botón
  final Color? backgroundColor;  // Color de fondo (opcional)
  final double borderRadius;  // Radio del borde (opcional)
  final double padding;  // Padding del botón


  const DefaultButton({
    Key? key,
    required this.onPressed,  // La función de confirmación que se pasa
    required this.text,  // Texto del botón
    this.backgroundColor = Colors.green,  // Por defecto el color de fondo es verde
    this.borderRadius = 30.0,  // Borde redondeado por defecto
    this.padding = 15.0,  // Padding por defecto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? backgroundColor : Colors.grey,  // Cambia el color si está deshabilitado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),  // Borde redondeado personalizado
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),  // Padding interno
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,  // Color del texto en blanco
          ),
        ),
      ),
    );
  }
}