import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/enums/menu_action.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/services/notes_service.dart';
import 'package:belanjaku/utility/dialog/logout_dialog.dart';
import 'package:belanjaku/views/notes/note_list.dart';
import 'package:flutter/material.dart';

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

/*
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            writeLog(value.toString());
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  writeLog('User logout');

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
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final notes = snapshot.data as List<DatabaseNotes>;
                        writeLog("List notes: ${notes.toString()}");
                        return NoteListView(
                          notes: notes,
                          onDeleteNote: (note) async {
                            writeLog("Note to delete: ${note.text} ");
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTapNote: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const Text('Menunggu data...');
                      }

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
