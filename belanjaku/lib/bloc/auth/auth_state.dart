import 'package:belanjaku/auth/auth_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingTxt;
  const AuthState(
      {required this.isLoading, this.loadingTxt = 'Sedang memproses...'});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLogin extends AuthState {
  final AuthUser user;
  const AuthStateLogin({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateVerification extends AuthState {
  const AuthStateVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLogout extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLogout(
      {required this.exception,
      required bool isLoading,
      String? loadingTxt = ''})
      : super(isLoading: isLoading, loadingTxt: loadingTxt);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword(
      {required this.exception,
      required this.hasSentEmail,
      required bool isLoading})
      : super(isLoading: isLoading);
}
