import 'package:belanjaku/services/cloud/cloud_note.dart';
import 'package:belanjaku/services/cloud/cloud_storage_constant.dart';
import 'package:belanjaku/services/cloud/cloud_storage_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future deleteNote({required String docId}) async {
    try {
      await notes.doc(docId).delete();
    } catch (e) {
      GagalMenghapusNoteException();
    }
  }

  Future updateNote({required String docId, required String txt}) async {
    try {
      await notes.doc(docId).update({textField: txt});
    } catch (ex) {
      throw GagalMengupdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerUserId == ownerId));
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerId}) async {
    try {
      return await notes
          .where(
            userIdField,
            isEqualTo: ownerId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(
                  doc) /*{
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[userIdField] as String,
                  text: doc.data()[textField] as String,
                );
              }*/
              ,
            ),
          );
    } catch (e) {
      throw GagalMembukaSemuaNoteException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerId}) async {
    final doc = await notes.add({
      userIdField: ownerId,
      textField: '',
    });

    final fetchNote = await doc.get();
    return CloudNote(documentId: fetchNote.id, ownerUserId: ownerId, text: '');
  }

  //Singleton
  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();

  FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;
}
