
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBlocCubit extends Cubit<LoginBloc> {
  LoginBlocCubit(): super(LoginInitial());

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void changeEmail(String email) => _emailController.sink.add(email);
  void changePassword(String password) => _passwordController.sink.add(password);

  void login(){
    final email = _emailController.value;
    final password = _passwordController.value;
    print('Email: $email');
    print('Password: $password');
  }
}