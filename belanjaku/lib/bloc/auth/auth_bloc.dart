import 'package:belanjaku/auth/auth_provider.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    ///Proses initilaisasi
    on<AuthEventInit>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLogout());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateVerification());
        } else {
          emit(AuthStateLogin(user));
        }
      },
    );

    ///Login
    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoading());
        final email = event.email;
        final pwd = event.pwd;

        try {
          final user = await provider.login(email: email, passwd: pwd);
          emit(AuthStateLogin(user));
        } on Exception catch (e) {
          emit(AuthStateOnFailure(e));
        }
      },
    );

    ///Logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logOut();
          emit(const AuthStateLogout());
        } on Exception catch (e) {
          emit(AuthStateOnFailure(e));
        }
      },
    );
  }
}
