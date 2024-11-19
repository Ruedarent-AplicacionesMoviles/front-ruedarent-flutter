import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const termsAndConditions = """
    Términos y Condiciones

    1. Introducción
    Bienvenido a nuestra plataforma. Estos términos y condiciones regulan el uso de nuestra aplicación. Al usar la aplicación, aceptas estos términos.

    2. Responsabilidad
    El usuario es responsable de proporcionar información precisa y mantener la confidencialidad de su cuenta. No somos responsables por el uso indebido de la información.

    3. Privacidad
    Respetamos tu privacidad. Consulta nuestra Política de Privacidad para más detalles sobre cómo manejamos tus datos.

    4. Modificaciones
    Nos reservamos el derecho de modificar estos términos en cualquier momento. Los cambios serán efectivos al publicarlos en la aplicación.

    5. Uso Permitido
    Queda prohibido usar la aplicación para actividades ilegales o no autorizadas.

    6. Propiedad Intelectual
    Todo el contenido de la aplicación, incluidos textos, gráficos, logos, y diseños, es propiedad de la empresa.

    7. Contacto
    Si tienes preguntas, puedes contactarnos en:
    Correo: ruedarent@upc.edu.pe
    Teléfono: 932123933


    Gracias por usar nuestra aplicación.
    """;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          termsAndConditions,
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ),
    );
  }
}