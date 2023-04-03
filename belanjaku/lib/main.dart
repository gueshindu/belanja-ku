import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/views/halaman_login.dart';
import 'package:belanjaku/views/halaman_note.dart';
import 'package:belanjaku/views/halaman_register.dart';
import 'package:belanjaku/views/halaman_verifikasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

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
    },
  ));
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                devtools.log("Logged & verified");
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
