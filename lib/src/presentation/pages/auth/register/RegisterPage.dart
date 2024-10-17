import 'package:flutter/material.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/widgets/DefaultButton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Estado del checkbox de términos y condiciones
  bool isAcceptedTerms = false;
  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Función que se ejecuta al presionar "CONFIRMAR"
  void _confirmRegistration() {
    if (!_formKey.currentState!.validate()) {
      // Si el formulario no es válido, no hace nada
      return;
    }

    if (!isAcceptedTerms) {
      // Si no ha aceptado los términos, mostramos un mensaje de advertencia
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Advertencia'),
            content: const Text(
              'Debes aceptar los Términos de servicio y la Política de privacidad para continuar.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Aquí iría la lógica para registrar al usuario, si todo está validado
      print("Registro exitoso");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        title: const Text(
          'Registro',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido de la pantalla
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20), // Espacio superior
                // Ícono y texto centrado
                const Column(
                  children: const [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'INGRESA ESTA INFORMACIÓN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Espacio entre el título y el formulario
                // Formulario del registro
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey, // Clave del formulario
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REGISTRARSE',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Campo de Nombres
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombres',
                              filled: true,
                              fillColor: Color(0xFFDFF2D8),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de Apellidos
                          TextFormField(
                            controller: _surnameController,
                            decoration: const InputDecoration(
                              labelText: 'Apellidos',
                              filled: true,
                              fillColor: Color(0xFFDFF2D8),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese sus apellidos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de Correo electrónico
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              filled: true,
                              fillColor: Color(0xFFDFF2D8),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo electrónico';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de Contraseña
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              filled: true,
                              fillColor: Color(0xFFDFF2D8),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de Confirmar Contraseña
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              filled: true,
                              fillColor: Color(0xFFDFF2D8),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme su contraseña';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Checkbox de términos y condiciones
                          Row(
                            children: [
                              Checkbox(
                                value: isAcceptedTerms,  // El valor depende del estado
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAcceptedTerms = value ?? false;  // Actualizamos el estado del checkbox
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Acepto los Términos de servicio y la Política de privacidad',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Botón de confirmar
                          SizedBox(
                            width: double.infinity,
                            child: DefaultButton(
                              onPressed: _confirmRegistration,
                              text: 'CONFIRMAR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}