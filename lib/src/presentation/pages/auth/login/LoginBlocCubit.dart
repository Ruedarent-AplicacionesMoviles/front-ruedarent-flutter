import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import 'LoginBlocState.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  LoginBlocCubit() : super(LoginInitial());

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void changeEmail(String email) {
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
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
    } else {
      _passwordController.sink.add(password);
    }
  }

  Stream<bool> get formValidStream => Rx.combineLatest2(
    emailStream,
    passwordStream,
        (email, password) => true,
  );

  // Método para login
  Future<void> login({bool isTestUser = false}) async {
    try {
      emit(LoginLoading());

      if (isTestUser) {
        // Login automático para usuario de prueba
        UserModel testUser = UserModel(
          name: 'Test User',
          email: 'testuser@domain.com',
          password: 'Password123!',
          userType: 'owner', // o el tipo de usuario que prefieras
          notificationPreferences: 'all',
        );
        emit(LoginSuccess(testUser));
        return;
      }

      UserRepository userRepo = UserRepository();
      final email = _emailController.value.trim();
      final password = _passwordController.value.trim();

      // Verificar si el usuario existe y las credenciales son correctas
      UserModel? user = await userRepo.getUserByEmail(email);
      if (user == null || user.password != password) {
        emit(LoginError('Correo o contraseña incorrectos.'));
      } else {
        emit(LoginSuccess(user)); // Si el login es exitoso, emitir el éxito
      }
    } catch (e) {
      emit(LoginError('Error al iniciar sesión: $e'));
    }
  }

  @override
  Future<void> close() {
    _emailController.close();
    _passwordController.close();
    return super.close();
  }
}