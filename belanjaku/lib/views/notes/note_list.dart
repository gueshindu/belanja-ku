import 'package:belanjaku/services/notes_service.dart';
import 'package:belanjaku/utility/dialog/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef DeleteNoteCallback = void Function(DatabaseNotes note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
  }) : super(key: key);

  final DeleteNoteCallback onDeleteNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final curNote = notes[index];
        return ListTile(
          title: Text(
            curNote.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(curNote);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
