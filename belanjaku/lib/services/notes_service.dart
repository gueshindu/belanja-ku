/* import 'dart:async';

import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/extension/list_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

import 'notes_service_exception.dart';

class NotesService {
  //Singleton
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamCtrl =
        StreamController<List<DatabaseNotes>>.broadcast(onListen: () {
      _notesStreamCtrl.sink.add(_notes);
    });
  }
  factory NotesService() => _shared;

  Database? _db;
  DatabaseUser? _curUser; //Save current user data

  List<DatabaseNotes> _notes = [];

  late final StreamController<List<DatabaseNotes>>
      _notesStreamCtrl; //  = StreamController<List<DatabaseNotes>>.broadcast();

  Stream<List<DatabaseNotes>> get allNotes => _notesStreamCtrl.stream.filter(
        (note) {
          final curUser = _curUser;
          if (curUser != null) {
            return note.userId == curUser.id;
          } else {
            throw DBUserNotSet();
          }
        },
      );

  Future _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamCtrl.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DBNotOpen();
    return db;
  }

  Future<DatabaseUser> getOrCrateUser(
      {required String email, bool setAsCurUser = true}) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurUser) _curUser = user;
      return user;
    } on UserNotFoundException {
      final createdUser = await createUser(email: email);
      if (setAsCurUser) _curUser = createdUser;
      writeLog("User created: $email");
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      tblUser,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) throw DBUserExist();

    final userid = await db.insert(
      tblUser,
      {
        colEmail: email.toLowerCase(),
      },
    );

    return DatabaseUser(id: userid, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      tblUser,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      writeLog("User with email $email not found");
      throw UserNotFoundException();
    }

    return DatabaseUser.fromRow(result.first);
  }

  Future deleteUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      tblUser,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw DBDeleteUserFail();
    }
  }

  Future<DatabaseNotes> createNotes({required DatabaseUser creator}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: creator.email);

    if (dbUser != creator) throw DBUserNotExist();

    const txt = '';
    final noteID = await db.insert(tblNote, {
      colUserId: creator.id,
      colText: txt,
      colIsSync: 1,
    });

    final note =
        DatabaseNotes(id: noteID, userId: creator.id, text: txt, isSync: true);
    _notes.add(note);
    _notesStreamCtrl.add(_notes);

    return note;
  }

  Future<DatabaseNotes> getNotes({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      tblNote,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );

    if (result.isEmpty) throw DBNoteNotExist();

    final note = DatabaseNotes.fromRow(result.first);
    _notes.removeWhere((element) => element.id == id);
    _notes.add(note);
    _notesStreamCtrl.add(_notes);

    return note;
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      tblNote,
    );

    return results.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes note, required String newText}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();

    //Cek note exist
    await getNotes(id: note.id);

    //Update to db
    final result = await db.update(
      tblNote,
      {
        colText: newText,
        colIsSync: 0,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (result == 0) throw DBFailUpdateNoteFail();
    final updateNote = await getNotes(id: note.id);
    _notes.removeWhere((element) => element.id == updateNote.id);
    _notes.add(updateNote);
    _notesStreamCtrl.add(_notes);
    return updateNote;
  }

  Future deleteNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      tblNote,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount != 1) {
      throw DBDeleteNoteFail();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamCtrl.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    final numDeleted = await db.delete(
      tblNote,
    );
    _notes = [];
    _notesStreamCtrl.add(_notes);

    return numDeleted;
  }

  Future close() async {
    final db = _db;
    if (db == null) {
      throw DBNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future open() async {
    if (_db != null) {
      //writeLog('Database already open. ${_db.toString()}');
      throw DBAlreadyOpenException();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //Create user
      await db.execute(createUserScript);
      //create note
      await db.execute(createNoteScript);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      writeLog('Fail to open database');
      throw DBUnableOpen();
    }
  }

  Future _ensureDBIsOpen() async {
    try {
      await open();
    } on DBAlreadyOpenException {}
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[colID] as int,
        email = map[colEmail] as String;
  //Map <String, Object?>

  @override
  String toString() {
    return "User id: $id, email: $email";
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSync;

  const DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSync,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[colID] as int,
        userId = map[colUserId] as int,
        text = map[colText] as String,
        isSync = map[colIsSync] == 1;
  //Map <String, Object?>

  @override
  String toString() {
    return "Note id: $id, User id: $userId, Text: $text, Sync = $isSync";
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const tblNote = 'note';
const tblUser = 'user';
const colID = 'id';
const colEmail = 'email';
const colUserId = 'user_id';
const colText = 'text';
const colIsSync = 'is_synced';

const createUserScript = ''' 
      CREATE TABLE IF NOT EXISTS "$tblUser"  (
        "$colID" INTEGER NOT NULL,
        "$colEmail" TEXT NOT NULL UNIQUE,
        PRIMARY KEY ("$colID" AUTOINCREMENT)
      );
      ''';

const createNoteScript = ''' 
      CREATE TABLE IF NOT EXISTS "$tblNote"  (
        "$colID" INTEGER NOT NULL,
        "$colUserId" INTEGER NOT NULL,
        "$colText" TEXT,
        "$colIsSync" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY ("$colUserId") REFERENCES "$tblUser"("$colID"),
        PRIMARY KEY ("$colID" AUTOINCREMENT)
      );
      ''';
 */