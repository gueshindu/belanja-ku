import 'auth_user.dart';

abstract class AuthProvider {
  Future initialize();
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
  Future passwordReset({
    required String email,
  });
}
