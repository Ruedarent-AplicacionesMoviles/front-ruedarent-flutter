// src/presentation/pages/auth/login/LoginBlocState.dart

import '../../../../data/models/user_model.dart';

abstract class LoginBlocState {}

class LoginInitial extends LoginBlocState {}

class LoginLoading extends LoginBlocState {}

class LoginSuccess extends LoginBlocState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginFailure extends LoginBlocState {
  final String error;

  LoginFailure(this.error);
}
