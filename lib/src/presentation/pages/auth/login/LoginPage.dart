import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginBlocCubit.dart';
import 'LoginBlocState.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBlocCubit _loginBlocCubit;

  @override
  void initState() {
    super.initState();
    _loginBlocCubit = BlocProvider.of<LoginBlocCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBlocCubit, LoginBlocState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navegar a la pantalla de roles después del login exitoso
            Navigator.pushReplacementNamed(context, '/roles', arguments: state.user);
          } else if (state is LoginError) {
            // Mostrar mensaje de error si el login falla
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100), // Espacio superior
                // Logo de la aplicación
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 50), // Espacio entre logo y formulario
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
                      _buildTextField(
                        stream: _loginBlocCubit.emailStream,
                        onChanged: _loginBlocCubit.changeEmail,
                        labelText: 'Correo electrónico',
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      // Campo de contraseña
                      _buildTextField(
                        stream: _loginBlocCubit.passwordStream,
                        onChanged: _loginBlocCubit.changePassword,
                        labelText: 'Contraseña',
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      // Enlace para olvidar la contraseña
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/password-recovery');
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
                        child: StreamBuilder<bool>(
                          stream: _loginBlocCubit.formValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.hasData
                                  ? () {
                                _loginBlocCubit.login();
                              }
                                  : null,
                              child: const Text('Login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: snapshot.hasData ? Colors.green : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
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
          );
        },
      ),
    );
  }

  // Método para construir campos de texto
  Widget _buildTextField({
    required Stream<String> stream,
    required Function(String) onChanged,
    required String labelText,
    IconData? icon,
    bool isPassword = false,
  }) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: const Color(0xFFDFF2D8),
            border: const OutlineInputBorder(),
            errorText: snapshot.error?.toString(),
          ),
        );
      },
    );
  }
}