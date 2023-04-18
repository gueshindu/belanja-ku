import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/views/halaman_login.dart';
import 'package:belanjaku/views/notes/halaman_note.dart';
import 'package:belanjaku/views/halaman_register.dart';
import 'package:belanjaku/views/halaman_verifikasi.dart';
import 'package:belanjaku/views/notes/note_baru.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Belanja Ku',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HalamanUtama(),
    routes: {
      mainRoute: (context) => const HalamanUtama(),
      loginRoute: (context) => const HalamanLogin(),
      registerRoute: (context) => const HalamanDaftar(),
      notesRoute: (context) => const HalamanNotes(),
      verifyEmailRoute: (context) => const HalamanVerifikasi(),
      newNotesRoute: (context) => const NewNotesView(),
    },
  ));
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
