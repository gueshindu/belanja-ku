import 'package:belanjaku/auth/auth_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
const AuthStateUninitialized();
}
 
class AuthStateLogin extends AuthState {
  final AuthUser user;
  const AuthStateLogin(this.user);
}

class AuthStateVerification extends AuthState {
  const AuthStateVerification();
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);

}

class AuthStateLogout extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLogout({required this.exception, required this.isLoading});
  
  @override
  List<Object?> get props => [exception, isLoading];
}

