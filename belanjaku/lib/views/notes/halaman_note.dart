import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/enums/menu_action.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/services/cloud/cloud_note.dart';
import 'package:belanjaku/services/cloud/firebase_cloud_storage.dart';
import 'package:belanjaku/utility/dialog/logout_dialog.dart';
import 'package:belanjaku/views/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HalamanNotes extends StatefulWidget {
  const HalamanNotes({Key? key}) : super(key: key);

  @override
  State<HalamanNotes> createState() => _HalamanNotesState();
}

class _HalamanNotesState extends State<HalamanNotes> {
  late final FireBaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FireBaseCloudStorage();
    super.initState();
  }

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
                  context.read<AuthBloc>().add(
                        const AuthEventLogout(),
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
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final notes = snapshot.data as Iterable<CloudNote>;
                writeLog("List notes: ${notes.toString()}");
                return NoteListView(
                  notes: notes,
                  onDeleteNote: (note) async {
                    writeLog("Note to delete: ${note.text} ");
                    await _notesService.deleteNote(docId: note.documentId);
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
      ),
    );
  }
}
