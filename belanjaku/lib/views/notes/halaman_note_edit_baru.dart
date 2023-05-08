import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/services/cloud/cloud_note.dart';
import 'package:belanjaku/services/cloud/firebase_cloud_storage.dart';
import 'package:belanjaku/utility/dialog/cannot_share.dart';
import 'package:belanjaku/utility/generics/get_argument.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HalamanNewUpdate extends StatefulWidget {
  const HalamanNewUpdate({Key? key}) : super(key: key);

  @override
  State<HalamanNewUpdate> createState() => _HalamanNewUpdateState();
}

class _HalamanNewUpdateState extends State<HalamanNewUpdate> {
  CloudNote? _note;
  late final FireBaseCloudStorage _service;
  late final TextEditingController _txtController;

  @override
  void initState() {
    _service = FireBaseCloudStorage();
    _txtController = TextEditingController();
    super.initState();
  }

  void _textCtrlListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final txt = _txtController.text;
    await _service.updateNote(docId: note.documentId, txt: txt);
  }

  void _setupListener() {
    _txtController.removeListener(_textCtrlListener);
    _txtController.addListener(_textCtrlListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext ctx) async {
    final widgetNote = ctx.getArgument<CloudNote>();
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
    final newNote = await _service.createNewNote(ownerId: curUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteEmptyNote() {
    final note = _note;
    if (_txtController.text.isEmpty && note != null) {
      _service.deleteNote(docId: note.documentId);
    }
  }

  void _saveNote() async {
    final note = _note;
    final txt = _txtController.text;
    if (note != null && txt.isNotEmpty) {
      await _service.updateNote(docId: note.documentId, txt: txt);
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
        actions: [
          IconButton(
            onPressed: () async {
              final txt = _txtController.text;
              if (_note == null || txt.isEmpty) {
                tdkBisaShareDialog(context);
              } else {
                Share.share(txt);
              }
            },
            icon: const Icon(
              Icons.share,
            ),
          )
        ],
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
