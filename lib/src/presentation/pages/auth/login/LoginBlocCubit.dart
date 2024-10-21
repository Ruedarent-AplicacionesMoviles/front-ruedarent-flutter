import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import 'LoginBlocState.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final UserRepository _userRepository;

  LoginBlocCubit(this._userRepository) : super(LoginInitial());

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void changeEmail(String email) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (email.length < 3) {
      _emailController.sink.addError('El email debe tener más de 3 caracteres');
    } else if (!emailRegExp.hasMatch(email)) {
      _emailController.sink.addError('El email debe ser válido');
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

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (email, password) {
        return _validateEmail(email) && _validatePassword(password);
      });

  bool _validateEmail(String email) {
    return email.length >= 3 && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.length >= 6 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Future<bool> login() async {
    emit(LoginLoading());
    try {
      final email = _emailController.value;
      final password = _passwordController.value;

      print('Intentando iniciar sesión con Email: $email y Password: $password');
      UserModel? user = await _userRepository.getUserByEmail(email);

      if (user != null) {
        print('Usuario encontrado: ${user.email}');
        if (user.password == password) {
          print('Contraseña correcta');
          emit(LoginSuccess(user));
          return true;
        } else {
          print('Contraseña incorrecta');
          emit(LoginFailure('Contraseña incorrecta'));
          return false;
        }
      } else {
        print('Usuario no encontrado con el email: $email');
        emit(LoginFailure('Usuario no encontrado'));
        return false;
      }
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      emit(LoginFailure('Error en el inicio de sesión: $e'));
      return false;
    }
  }

  void printAllUsers() async {
    List<UserModel> users = await _userRepository.getAllUsers();
    for (UserModel user in users) {
      print('Usuario: ${user.email}, Contraseña: ${user.password}');
    }
  }

  Future<void> insertTestUser(UserModel user) async {
    await _userRepository.insertUser(user);
    print('Usuario de prueba insertado: ${user.email}');
  }

}
