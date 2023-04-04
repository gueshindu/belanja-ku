import 'package:belanjaku/services/auth/auth_provider.dart';
import 'package:belanjaku/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser({required String email, required passwd}) =>
      provider.createUser(email: email, passwd: passwd);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future logOut() => provider.logOut();
  @override
  Future<AuthUser> login({required String email, required passwd}) =>
      provider.login(email: email, passwd: passwd);

  @override
  Future sentEmailVerification() => provider.sentEmailVerification();
}
