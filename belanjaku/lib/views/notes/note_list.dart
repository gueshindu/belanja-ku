import 'package:belanjaku/services/cloud/cloud_note.dart';
import 'package:belanjaku/utility/dialog/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  }) : super(key: key);

  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final curNote = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTapNote(curNote);
          },
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
