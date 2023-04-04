import 'package:belanjaku/services/auth/auth_exception.dart';
import 'package:belanjaku/services/auth/auth_provider.dart';
import 'package:belanjaku/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({required String email, required passwd}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passwd);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordException();
        case 'email-already-in-use':
          throw EmailAlreadyExistException();
        case 'invalid-email':
          throw InvalidEmailException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

  @override
  Future logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Future<AuthUser> login({required String email, required passwd}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passwd);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException();
        case 'wrong-password':
          throw WrongPasswordException();
        default:
          throw GenericAuthException();
      }
    } catch (ex) {
      throw GenericAuthException();
    }
  }

  @override
  Future sentEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoginException();
    }
  }
}
