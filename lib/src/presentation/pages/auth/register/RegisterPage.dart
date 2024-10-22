import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'RegisterBlocCubit.dart';
import 'RegisterBlocState.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late RegisterBlocCubit _registerBlocCubit;
  bool isAcceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _registerBlocCubit = BlocProvider.of<RegisterBlocCubit>(context);
  }

  void _confirmRegistration() {
    _registerBlocCubit.register();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        title: const Text('Registro', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<RegisterBlocCubit, RegisterBlocState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            // Mostrar loading
          } else if (state is RegisterSuccess) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Formulario de registro
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
                        const Text('REGISTRARSE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _buildTextField(
                          stream: _registerBlocCubit.nameStream,
                          onChanged: _registerBlocCubit.changeName,
                          labelText: 'Nombres',
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          stream: _registerBlocCubit.surnameStream,
                          onChanged: _registerBlocCubit.changeSurname,
                          labelText: 'Apellidos',
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          stream: _registerBlocCubit.emailStream,
                          onChanged: _registerBlocCubit.changeEmail,
                          labelText: 'Correo electrónico',
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          stream: _registerBlocCubit.passwordStream,
                          onChanged: _registerBlocCubit.changePassword,
                          labelText: 'Contraseña',
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          stream: _registerBlocCubit.confirmPasswordStream,
                          onChanged: _registerBlocCubit.changeConfirmPassword,
                          labelText: 'Confirmar Contraseña',
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
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
                        Center(
                          child: StreamBuilder<bool>(
                            stream: _registerBlocCubit.formValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: (snapshot.hasData && isAcceptedTerms)
                                    ? _confirmRegistration
                                    : null,
                                child: const Text('CONFIRMAR'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (snapshot.hasData && isAcceptedTerms) ? Colors.green : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
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
      ),
    );
  }

  Widget _buildTextField({
    required Stream<String> stream,
    required Function(String) onChanged,
    required String labelText,
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