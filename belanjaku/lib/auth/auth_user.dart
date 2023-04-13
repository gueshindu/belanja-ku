import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? userEmail;

  const AuthUser({required this.userEmail, required this.isEmailVerified});

  factory AuthUser.fromFirebase(FirebaseAuth.User user) =>
      AuthUser(userEmail: user.email, isEmailVerified: user.emailVerified);
}
