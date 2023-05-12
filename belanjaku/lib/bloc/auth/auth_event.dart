import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInit extends AuthEvent {
  const AuthEventInit();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String pwd;

  const AuthEventLogin(this.email, this.pwd);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}
