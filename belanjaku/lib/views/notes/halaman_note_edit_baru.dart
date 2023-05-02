import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/services/notes_service.dart';
import 'package:belanjaku/utility/generics/get_argument.dart';
import 'package:flutter/material.dart';

class HalamanNewUpdate extends StatefulWidget {
  const HalamanNewUpdate({Key? key}) : super(key: key);

  @override
  State<HalamanNewUpdate> createState() => _HalamanNewUpdateState();
}

class _HalamanNewUpdateState extends State<HalamanNewUpdate> {
  DatabaseNotes? _note;
  late final NotesService _service;
  late final TextEditingController _txtController;

  @override
  void initState() {
    _service = NotesService();
    _txtController = TextEditingController();
    super.initState();
  }

  void _textCtrlListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final txt = _txtController.text;
    await _service.updateNote(note: note, newText: txt);
  }

  void _setupListener() {
    _txtController.removeListener(_textCtrlListener);
    _txtController.addListener(_textCtrlListener);
  }

  Future<DatabaseNotes> createOrGetExistingNote(BuildContext ctx) async {
    final widgetNote = ctx.getArgument<DatabaseNotes>();
    if (widgetNote != null) {
      _note = widgetNote;
      _txtController.text = widgetNote.text;
      return widgetNote;
    }

    final curNote = _note;
    if (curNote != null) {
      return curNote;
    }
    final curUser = AuthService.firebase().currentUser!;
    final email = curUser.userEmail!;
    final owner = await _service.getUser(email: email);

    final newNote = await _service.createNotes(creator: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteEmptyNote() {
    final note = _note;
    if (_txtController.text.isEmpty && note != null) {
      _service.deleteNote(id: note.id);
    }
  }

  void _saveNote() async {
    final note = _note;
    final txt = _txtController.text;
    if (note != null && txt.isNotEmpty) {
      await _service.updateNote(note: note, newText: txt);
    }
  }

  @override
  void dispose() {
    _deleteEmptyNote();
    _saveNote();
    _txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Baru"),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupListener();
              return TextField(
                controller: _txtController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Catatan kamu.."),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
