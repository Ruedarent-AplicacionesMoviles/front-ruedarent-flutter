import '../../../../data/models/user_model.dart';

abstract class LoginBlocState {}

class LoginInitial extends LoginBlocState {}

class LoginLoading extends LoginBlocState {}

class LoginSuccess extends LoginBlocState {
  final UserModel user;
  LoginSuccess(this.user);
}

class LoginError extends LoginBlocState {
  final String message;
  LoginError(this.message);
}