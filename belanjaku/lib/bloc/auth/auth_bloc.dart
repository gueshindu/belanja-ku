import 'package:belanjaku/auth/auth_provider.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {

    //Membuka Halaman Register
    on <AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );
    
    //Kirim email verifikasi
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sentEmailVerification();
        emit(state);
      },
    );

    ///Register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final passwd = event.pwd;

        try {
          await provider.createUser(email: email, passwd: passwd);
          await provider.sentEmailVerification();
          emit(const AuthStateNeedVerification(isLoading: false));
        } on Exception catch (exception) {
          emit(AuthStateRegistering(exception: exception, isLoading: false));
        }

        emit(state);
      },
    );

    ///Proses initilaisasi
    on<AuthEventInit>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLogout(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateVerification(isLoading: false));
        } else {
          emit(AuthStateLogin(user: user, isLoading: false));
        }
      },
    );

    ///Login
    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLogout(
            exception: null, isLoading: true, loadingTxt: 'Menunggu login...'));

        final email = event.email;
        final pwd = event.pwd;
        writeLog("Login user: $email");
        try {
          final user = await provider.login(email: email, passwd: pwd);

          if (!user.isEmailVerified) {
            emit(const AuthStateLogout(exception: null, isLoading: false));
            emit(const AuthStateNeedVerification(isLoading: false));
          } else {
            emit(const AuthStateLogout(exception: null, isLoading: false));
            writeLog("Success");
            emit(AuthStateLogin(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          writeLog("Failed");
          emit(AuthStateLogout(exception: e, isLoading: false));
        }
      },
    );

    ///Logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLogout(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLogout(exception: e, isLoading: false));
        }
      },
    );
  }
}
