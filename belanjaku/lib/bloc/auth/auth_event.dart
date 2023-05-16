import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInit extends AuthEvent {
  const AuthEventInit();
}

class AuthEventLogin extends AuthEvent {
  final String email, pwd;

  const AuthEventLogin(this.email, this.pwd);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  final String email, pwd;
  const AuthEventRegister(this.email, this.pwd);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
