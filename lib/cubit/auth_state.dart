part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class LoadingState extends AuthState {}

class PhoneSubmitState extends AuthState {}

class OtpVerifiedState extends AuthState {}

class LoggedInState extends AuthState {
  final User firebaseUser;

  LoggedInState(this.firebaseUser);
}

class LoggedOutState extends AuthState {}

class ErrorState extends AuthState {
  ErrorState(this.errorMessage);
  final String errorMessage;
}

class NumberChangedState extends AuthState {
  final int number;

  NumberChangedState(this.number);
}
