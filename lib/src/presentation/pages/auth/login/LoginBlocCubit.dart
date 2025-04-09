import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/UserProvider.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import 'LoginBlocState.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final UserRepository _userRepository;
  final UserProvider _userProvider;

  LoginBlocCubit(this._userRepository, this._userProvider) : super(LoginInitial());

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void changeEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (email.trim().isEmpty) {
      _emailController.sink.addError('Por favor ingrese su email');
    } else if (!emailRegExp.hasMatch(email)) {
      _emailController.sink.addError('El email debe ser válido');
    } else {
      _emailController.sink.add(email);
    }
  }

  void changePassword(String password) {
    if (password.trim().isEmpty) {
      _passwordController.sink.addError('Por favor ingrese su contraseña');
    } else if (password.length < 6) {
      _passwordController.sink.addError('Debe tener al menos 6 caracteres');
    } else {
      _passwordController.sink.add(password);
    }
  }

  Stream<bool> get formValidStream => Rx.combineLatest2(
    emailStream,
    passwordStream,
        (email, password) => true,
  );

  // Método de login real
  Future<void> login({bool isTestUser = false}) async {
    try {
      emit(LoginLoading());

      if (isTestUser) {
        final testUser = UserModel(
          id: 1,
          name: 'Test User',
          email: 'testuser@domain.com',
          password: '',
          userType: 'owner',
          notificationPreferences: 'all',
        );
        emit(LoginSuccess(testUser));
        _userProvider.setUserId(testUser.id!);
        return;
      }

      final email = _emailController.value.trim();
      final password = _passwordController.value.trim();

      final user = await _userRepository.loginUser(email, password);

      emit(LoginSuccess(user));
      _userProvider.setUserId(user.id!);
    } catch (e) {
      emit(LoginError('Correo o contraseña incorrectos'));
    }
  }

  @override
  Future<void> close() {
    _emailController.close();
    _passwordController.close();
    return super.close();
  }
}
