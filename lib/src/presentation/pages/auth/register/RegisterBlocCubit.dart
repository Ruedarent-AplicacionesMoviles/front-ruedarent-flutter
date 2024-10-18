import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'RegisterBlocState.dart';

class RegisterBlocCubit extends Cubit<RegisterBlocState> {
  RegisterBlocCubit() : super(RegisterInitial());

  // Controladores de los campos
  final _nameController = BehaviorSubject<String>();
  final _surnameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();

  // Streams para los campos
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get surnameStream => _surnameController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmPasswordStream => _confirmPasswordController.stream;

  // Validaciones
  void changeName(String name) {
    if (name.trim().isEmpty) {
      _nameController.sink.addError('Por favor ingrese su nombre');
    } else if (!RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$").hasMatch(name)) {
      _nameController.sink.addError('El nombre solo debe contener letras');
    } else if (name.length < 2) {
      _nameController.sink.addError('El nombre debe tener al menos 2 caracteres');
    } else {
      _nameController.sink.add(name);
    }
  }

  void changeSurname(String surname) {
    if (surname.trim().isEmpty) {
      _surnameController.sink.addError('Por favor ingrese sus apellidos');
    } else if (!RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$").hasMatch(surname)) {
      _surnameController.sink.addError('El apellido solo debe contener letras');
    } else if (surname.length < 2) {
      _surnameController.sink.addError('El apellido debe tener al menos 2 caracteres');
    } else {
      _surnameController.sink.add(surname);
    }
  }

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

  void changeConfirmPassword(String confirmPassword) {
    if (confirmPassword != _passwordController.value) {
      _confirmPasswordController.sink.addError('Las contraseñas no coinciden');
    } else {
      _confirmPasswordController.sink.add(confirmPassword);
    }
  }

  // Validación del formulario completo
  Stream<bool> get formValidStream => Rx.combineLatest5(
    nameStream,
    surnameStream,
    emailStream,
    passwordStream,
    confirmPasswordStream,
        (name, surname, email, password, confirmPassword) => true,
  );

  // Método para limpiar los streams
  void dispose() {
    _nameController.close();
    _surnameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
}