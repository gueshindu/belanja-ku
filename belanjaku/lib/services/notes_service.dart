import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

import 'notes_service_exception.dart';

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DBNotOpen();
    return db;
  }

  Future<DatabaseUser> crateUser({required String email}) async {
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
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      tblUser,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) throw DBUserNotExist();

    return DatabaseUser.fromRow(result.first);
  }

  Future deleteUser({required String email}) async {
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
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: creator.email);

    if (dbUser != creator) throw DBUserNotExist();

    const txt = '';
    final noteID = await db.insert(tblNote, {
      colUserId: creator.id,
      colText: txt,
      colIsSync: 1,
    });

    return DatabaseNotes(
        id: noteID, userId: creator.id, text: txt, isSync: true);
  }

  Future<DatabaseNotes> getNotes({required int id}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      tblNote,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );

    if (result.isEmpty) throw DBNoteNotExist();

    return DatabaseNotes.fromRow(result.first);
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      tblNote,
    );

    return results.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes note, required String newText}) async {
    final db = _getDatabaseOrThrow();

    await getNotes(id: note.id);

    final result = await db.update(tblNote, {
      colText: newText,
      colIsSync: 0,
    });

    if (result == 0) throw DBFailUpdateNoteFail();
    return await getNotes(id: note.id);
  }

  Future deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      tblNote,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount != 1) {
      throw DBDeleteNoteFail();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(
      tblNote,
    );
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
      throw DBAlreadyOpenException();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
//Create user
      db.execute(createUserScript);
//create note
      db.execute(createNoteScript);
    } on MissingPlatformDirectoryException {
      throw DBUnableOpen();
    }
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
    return "Note id: $id, User id: $userId [Sync = $isSync]";
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
        "$colIsSync" INTEGER NOT NULL DEFALT 0,
        FOREIGN KEY ("$colUserId") REFERENCES "$tblUser"("$colID"),
        PRIMARY KEY ("$colID" AUTOINCREMENT)
      );
      ''';
