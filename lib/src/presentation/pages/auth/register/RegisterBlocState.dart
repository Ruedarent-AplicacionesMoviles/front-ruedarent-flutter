// src/presentation/pages/auth/register/RegisterBlocState.dart

import '../../../../data/models/user_model.dart';

abstract class RegisterBlocState {}

class RegisterInitial extends RegisterBlocState {}

class RegisterLoading extends RegisterBlocState {}

class RegisterSuccess extends RegisterBlocState {}

class RegisterFailure extends RegisterBlocState {
  final String error;

  RegisterFailure(this.error);
}
