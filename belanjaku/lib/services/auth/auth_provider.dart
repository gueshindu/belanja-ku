import 'package:belanjaku/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required passwd,
  });

  Future<AuthUser> createUser({
    required String email,
    required passwd,
  });
  Future logOut();
  Future sentEmailVerification();
}
