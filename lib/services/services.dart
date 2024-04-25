import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference order =
      FirebaseFirestore.instance.collection('order');

  Future<void> addNote(String note) {
    return order.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        order.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  Future<void> updateNote(String docID, String newNote) {
    return order.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) {
    return order.doc(docID).delete();
  }
}