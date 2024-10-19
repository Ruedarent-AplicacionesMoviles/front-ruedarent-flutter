import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocState.dart';
import 'package:rxdart/rxdart.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  LoginBlocCubit(): super(LoginInitial());

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Streams para el email y el password
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  // Método para cambiar el email con validaciones
  void changeEmail(String email) {
    // Expresión regular general para validar correos electrónicos
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    // Validar longitud mínima
    if (email.length < 3) {
      _emailController.sink.addError('El email debe tener más de 3 caracteres');
    }
    // Validar formato del email
    else if (!emailRegExp.hasMatch(email)) {
      _emailController.sink.addError('El email debe ser válido (ej: usuario@dominio.com)');
    }
    // Si todo es correcto
    else {
      _emailController.sink.add(email);  // Si el email es válido, lo agregamos al stream
    }
  }

  // Método para cambiar el password con validaciones
  void changePassword(String password) {
    // Verificar longitud mínima
    if (password.length < 6) {
      _passwordController.sink.addError('Al menos 6 caracteres');
    }
    // Verificar si contiene al menos una letra mayúscula
    else if (!password.contains(RegExp(r'[A-Z]'))) {
      _passwordController.sink.addError('Debe contener una mayúscula');
    }
    // Verificar si contiene al menos una letra minúscula
    else if (!password.contains(RegExp(r'[a-z]'))) {
      _passwordController.sink.addError('Debe contener una minúscula');
    }
    // Verificar si contiene al menos un número
    else if (!password.contains(RegExp(r'[0-9]'))) {
      _passwordController.sink.addError('Debe contener un número');
    }
    // Verificar si contiene al menos un carácter especial
    else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordController.sink.addError('Debe contener un carácter especial');
    }
    // Si todo es correcto
    else {
      _passwordController.sink.add(password);  // Si la contraseña es válida, lo agregamos al stream
    }
  }

  // Validación del formulario completo
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (email, password) {
        return _validateEmail(email) && _validatePassword(password);
      });

  // Validaciones del email y el password
  bool _validateEmail(String email) {
    return email.length >= 3 && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.length >= 6 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  // Método para cerrar los streams y evitar fugas de memoria
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

  // Lógica para manejar el login
  Future<bool> login() async{
    final email = _emailController.value;
    final password = _passwordController.value;
    print('Email: $email');
    print('Password: $password');
    // Aquí podrías manejar la lógica del login, por ejemplo, llamar a una API
    await Future.delayed(Duration(seconds: 2));

    // Aquí deberías hacer la verificación real. Este es un ejemplo simulado:
    if (email == "test@domain.com" && password == "Password123!") {
      return true;  // Login exitoso
    } else {
      return false;  // Login fallido
    }
  }
}