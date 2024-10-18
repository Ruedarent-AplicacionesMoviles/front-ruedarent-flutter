import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/widgets/DefaultButton.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterBlocCubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Estado del checkbox de términos y condiciones
  bool isAcceptedTerms = false;
  late RegisterBlocCubit _registerBlocCubit;

  @override
  void initState() {
    super.initState();
    _registerBlocCubit = BlocProvider.of<RegisterBlocCubit>(context);
  }

  // Función para confirmar registro
  void _confirmRegistration() {
    // Aquí la lógica para registrar al usuario si todo está validado
    print("Registro exitoso");
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
                const SizedBox(height: 20),
                const Column(
                  children: [
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
                const SizedBox(height: 20),
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
                      StreamBuilder<String>(
                        stream: _registerBlocCubit.nameStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: _registerBlocCubit.changeName,
                            decoration: InputDecoration(
                              labelText: 'Nombres',
                              filled: true,
                              fillColor: const Color(0xFFDFF2D8),
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de Apellidos
                      StreamBuilder<String>(
                        stream: _registerBlocCubit.surnameStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: _registerBlocCubit.changeSurname,
                            decoration: InputDecoration(
                              labelText: 'Apellidos',
                              filled: true,
                              fillColor: const Color(0xFFDFF2D8),
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de Correo electrónico
                      StreamBuilder<String>(
                        stream: _registerBlocCubit.emailStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: _registerBlocCubit.changeEmail,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              filled: true,
                              fillColor: const Color(0xFFDFF2D8),
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de Contraseña
                      StreamBuilder<String>(
                        stream: _registerBlocCubit.passwordStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: _registerBlocCubit.changePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              filled: true,
                              fillColor: const Color(0xFFDFF2D8),
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de Confirmar Contraseña
                      StreamBuilder<String>(
                        stream: _registerBlocCubit.confirmPasswordStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: _registerBlocCubit.changeConfirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              filled: true,
                              fillColor: const Color(0xFFDFF2D8),
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Checkbox de términos y condiciones
                      Row(
                        children: [
                          Checkbox(
                            value: isAcceptedTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                isAcceptedTerms = value ?? false;
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
                      Center(
                        child: StreamBuilder<bool>(

                          stream: _registerBlocCubit.formValidStream,
                          builder: (context, snapshot) {
                            return DefaultButton(
                              onPressed: (snapshot.hasData && isAcceptedTerms) ? _confirmRegistration : null,  // Si no es válido, deshabilita el botón
                              text: 'CONFIRMAR',
                              backgroundColor: (snapshot.hasData && isAcceptedTerms)
                                  ? Colors.green
                                  : Colors.grey,
                            );
                          },
                        ),
                      ),
                    ],
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