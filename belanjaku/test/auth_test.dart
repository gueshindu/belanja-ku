import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/auth/auth_provider.dart';
import 'package:belanjaku/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock of auth', () {
    final provider = MockAuthProvider();

    test('Harusnya tidak auto inisialize', () {
      expect(provider.isInitialize, false);
    });

    test('Tidak bisa log out kalau blm di inisialisasi', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });

    test('Melakukan proses inisialisasi', () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    });

    test('User null setelah initialisasi', () async {
      expect(provider.currentUser, null);
    });

    test('Inisialisasi kurang dari 3 detik', () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    }, timeout: const Timeout(Duration(seconds: 3)));
  });
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInit = false;
  AuthUser? _user;

  bool get isInitialize => _isInit;

  @override
  Future<AuthUser> createUser({required String email, required passwd}) async {
    if (!isInitialize) {
      throw NotInitializeException();
    }

    await Future.delayed(const Duration(seconds: 2));
    return login(email: email, passwd: passwd);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInit = true;
  }

  @override
  Future logOut() async {
    if (!isInitialize) throw NotInitializeException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<AuthUser> login({required String email, required passwd}) {
    if (!isInitialize) throw NotInitializeException();
    if (email == '') throw UserNotFoundException();
    if (passwd == '') throw WrongPasswordException();
    const user = AuthUser(
        id: "xxx", isEmailVerified: false, userEmail: "tembelek@gajah.com");
    _user = user;
    return Future.value(user);
  }

  @override
  Future sentEmailVerification() async {
    if (!isInitialize) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(
        id: "xxx", isEmailVerified: true, userEmail: "tembelek@gajah.com");
    _user = newUser;
  }
}
