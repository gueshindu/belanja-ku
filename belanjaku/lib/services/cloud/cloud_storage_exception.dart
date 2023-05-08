class CloudStorageException implements Exception {
  const CloudStorageException();
}

//New
class GagalMembuatNoteException extends CloudStorageException {}

//Read
class GagalMembukaSemuaNoteException extends CloudStorageException {}

//Update
class GagalMengupdateNoteException extends CloudStorageException {}

//Delete
class GagalMenghapusNoteException extends CloudStorageException {}
