import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String userEmail;

  const AuthUser({
    required this.id,
    required this.userEmail,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(FirebaseAuth.User user) => AuthUser(
      id: user.uid,
      userEmail: user.email!,
      isEmailVerified: user.emailVerified);

  @override
  String toString() {
    return "User data. Email: $userEmail}";
  }
}
