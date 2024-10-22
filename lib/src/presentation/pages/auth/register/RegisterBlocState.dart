abstract class RegisterBlocState {}

class RegisterInitial extends RegisterBlocState {}

class RegisterLoading extends RegisterBlocState {}

class RegisterSuccess extends RegisterBlocState {}

class RegisterError extends RegisterBlocState {
  final String message;
  RegisterError(this.message);
}