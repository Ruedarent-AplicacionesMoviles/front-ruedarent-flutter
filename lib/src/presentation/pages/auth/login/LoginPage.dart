import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // TODO: implement initState
    super.initState();
    _loginBlocCubit = LoginBlocCubit();
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
                image: AssetImage('assets/images/background.png'), // Uso correcto de AssetImage
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
                              label: "Correo electronico",
                              icon: Icons.email,
                              onChanged: (text) {
                                _loginBlocCubit?.changeEmail(text);
                                // print('Correo ingresado: ${text}');
                              },
                          );
                        }
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
                              // print('Contraseña ingresada: ${text}');
                            },
                          );
                        }
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
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción para login
                            _loginBlocCubit?.login();
                            // Navigator.pushNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
                              'Registrate',
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