import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import 'RegisterBlocState.dart';
import 'package:sqflite/sqflite.dart';
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
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (email.length < 3) {
      _emailController.sink.addError('El email debe tener más de 3 caracteres');
    } else if (!emailRegExp.hasMatch(email)) {
      _emailController.sink.addError('El email debe ser válido (ej: usuario@dominio.com)');
    } else {
      _emailController.sink.add(email);
    }
  }

  void changePassword(String password) {
    if (password.length < 6) {
      _passwordController.sink.addError('Al menos 6 caracteres');
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      _passwordController.sink.addError('Debe contener una mayúscula');
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      _passwordController.sink.addError('Debe contener una minúscula');
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      _passwordController.sink.addError('Debe contener un número');
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordController.sink.addError('Debe contener un carácter especial');
    } else {
      _passwordController.sink.add(password);
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

  // Método para registrar un usuario en la base de datos
  Future<void> register() async {
    try {
      emit(RegisterLoading());

      UserRepository userRepo = UserRepository();
      UserModel newUser = UserModel(
        name: _nameController.value.trim(),
        email: _emailController.value.trim(),
        password: _passwordController.value.trim(),
        userType: 'renter', // Puedes modificar según tu lógica de negocio
        notificationPreferences: 'all', // Modificar según tu lógica
      );

      UserModel? existingUser = await userRepo.getUserByEmail(newUser.email);
      if (existingUser != null) {
        emit(RegisterError('El correo electrónico ya está registrado.'));
        return;
      }

      await userRepo.insertUser(newUser);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError('Error al registrar el usuario: $e'));
    }
  }

  // Método para limpiar los streams
  @override
  Future<void> close() {
    _nameController.close();
    _surnameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    return super.close();
  }
}
