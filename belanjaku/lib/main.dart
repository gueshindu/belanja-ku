import 'package:belanjaku/auth/auth_firebase.dart';
import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:belanjaku/bloc/view_test_bloc.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/views/halaman_login.dart';
import 'package:belanjaku/views/notes/halaman_note.dart';
import 'package:belanjaku/views/halaman_register.dart';
import 'package:belanjaku/views/halaman_verifikasi.dart';
import 'package:belanjaku/views/notes/halaman_note_edit_baru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Belanja Ku',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(AuthFirebaseProvider()),
      child: const HalamanUtama(),
    ),
    routes: {
      createOrUpdateRoute: (context) => const HalamanNewUpdate(),
      testRoute: (context) => const HalamanUtamaBloc(),
    },
  ));
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInit());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLogin) {
          return const HalamanNotes();
        } else if (state is AuthStateVerification) {
          return const HalamanVerifikasi();
        } else if (state is AuthStateLogout) {
          return const HalamanLogin();
        } else if (state is AuthStateRegistering ) {
          return const HalamanDaftar();
        }
        else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
/* 
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                writeLog("Logged & verified");
              } else {
                return const HalamanVerifikasi();
              }
            } else {
              return const HalamanLogin();
            }
            return const HalamanNotes();
          default:
            return const CircularProgressIndicator();
        }
      },
    ); */
  }
}
