import 'package:belanjaku/auth/auth_user.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLogin extends AuthState {
  final AuthUser user;
  const AuthStateLogin(this.user);
}

class AuthStateVerification extends AuthState {
  const AuthStateVerification();
}

class AuthStateOnFailure extends AuthState {
  final Exception exception;
  const AuthStateOnFailure(this.exception);
}

class AuthStateLogout extends AuthState {
  const AuthStateLogout();
}
