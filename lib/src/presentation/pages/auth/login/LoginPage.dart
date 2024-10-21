import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/widgets/DefaultTextfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBlocCubit? _loginBlocCubit;

  @override
  void initState() {
    super.initState();
    _loginBlocCubit = BlocProvider.of<LoginBlocCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _loginBlocCubit = BlocProvider.of<LoginBlocCubit>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Asegúrate de tener tu logo aquí
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido sobre la imagen
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100), // Espacio superior
                // Logo en el centro
                Center(
                  child: Image.asset(
                    'assets/images/logo.png', // Asegúrate de tener tu logo aquí
                    height: 150,
                  ),
                ),
                const SizedBox(height: 50), // Espacio entre el logo y el formulario
                // Contenedor con bordes redondeados para el formulario
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
                        'INGRESAR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo de correo electrónico
                      StreamBuilder(
                        stream: _loginBlocCubit?.emailStream,
                        builder: (context, snapshot) {
                          return DefaultTextfield(
                            label: "Correo electrónico",
                            icon: Icons.email,
                            onChanged: (text) {
                              _loginBlocCubit?.changeEmail(text);
                            },
                            errorText: snapshot.error != null ? snapshot.error.toString() : null, // Mostrar errores
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de contraseña
                      StreamBuilder(
                        stream: _loginBlocCubit?.passwordStream,
                        builder: (context, snapshot) {
                          return DefaultTextfield(
                            label: "Contraseña",
                            icon: Icons.lock,
                            isPassword: true,  // Aquí activamos el ocultamiento de texto
                            onChanged: (text) {
                              _loginBlocCubit?.changePassword(text);
                            },
                            errorText: snapshot.error != null ? snapshot.error.toString() : null, // Mostrar errores
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Enlace de "Has olvidado tu contraseña?"
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Acción para olvidar contraseña
                          },
                          child: const Text(
                            '¿Has olvidado tu contraseña?',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botón de login
                      SizedBox(
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: _loginBlocCubit?.formValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.hasData
                                  ? () async {
                                // Mostrar mensaje de inicio de sesión
                                Fluttertoast.showToast(
                                  msg: "Iniciando sesión...",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                                // Llamar al método login asíncrono del cubit
                                bool loginSuccess = await _loginBlocCubit?.login() ?? false;

                                // Si el login es exitoso, navegar a la página de roles
                                if (loginSuccess) {
                                  Navigator.pushNamed(context, '/roles');
                                } else {
                                  // Mostrar mensaje de error en caso de fallo en el login
                                  Fluttertoast.showToast(
                                    msg: "Error en el inicio de sesión. Por favor, inténtelo de nuevo.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }
                                  : null, // Deshabilitar el botón si no es válido
                              style: ElevatedButton.styleFrom(
                                backgroundColor: snapshot.hasData ? Colors.green : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Enlace para registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta?'),
                          TextButton(
                            onPressed: () {
                              // Acción para registro
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
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