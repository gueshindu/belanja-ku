import 'package:belanjaku/views/halaman_login.dart';
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
      '/login/': (context) => const HalamanLogin(),
      '/register/': (context) => const HalamanDaftar(),
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

enum MenuAction { logout }

class HalamanNotes extends StatefulWidget {
  const HalamanNotes({Key? key}) : super(key: key);

  @override
  State<HalamanNotes> createState() => _HalamanNotesState();
}

class _HalamanNotesState extends State<HalamanNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belanja Ku'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            devtools.log(value.toString());
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await logOutAlert(context);
                if (shouldLogout) {
                  devtools.log('User logout');
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (_) => false,
                  );
                }
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Logout"),
              ),
            ];
          }),
        ],
      ),
    );
  }
}

Future<bool> logOutAlert(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Yakin akan melakukan sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Ya'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
