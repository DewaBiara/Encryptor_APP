part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class Login extends AuthEvent {
  final AuthModel credentions;

  Login(this.credentions);
}

final class Logout extends AuthEvent {}
