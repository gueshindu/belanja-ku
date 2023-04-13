import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/enums/menu_action.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class HalamanNotes extends StatefulWidget {
  const HalamanNotes({Key? key}) : super(key: key);

  @override
  State<HalamanNotes> createState() => _HalamanNotesState();
}

class _HalamanNotesState extends State<HalamanNotes> {
  String get userEmail => AuthService.firebase().currentUser!.userEmail!;
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

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

                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
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
      body: FutureBuilder(
        future: _notesService.getOrCrateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Menunggu data...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
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
