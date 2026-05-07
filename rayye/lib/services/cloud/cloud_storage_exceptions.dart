class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {
  const CouldNotCreateNoteException();
}

class CouldNotGetAllNotesException extends CloudStorageException {
  const CouldNotGetAllNotesException();
}

class CouldNotUpdateNoteException extends CloudStorageException {
  const CouldNotUpdateNoteException();
}

class CouldNotDeleteNoteException extends CloudStorageException {
  const CouldNotDeleteNoteException();
}
