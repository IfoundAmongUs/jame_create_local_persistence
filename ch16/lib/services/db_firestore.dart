import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ch15/models/journal.dart';
import 'package:ch15/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = 'journals';

  DbFirestoreService();

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs =
          snapshot.docs.map((doc) => Journal.fromDoc(doc.data()!)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
      return _journalDocs;
    });
  }

  Future<Journal> getJournal(String documentID) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(_collectionJournals).doc(documentID).get();
    return Journal.fromDoc(documentSnapshot.data()!);
  }

  Future<bool> addJournal(Journal journal) async {
    try {
      DocumentReference _documentReference =
          await _firestore.collection(_collectionJournals).add({
        'date': journal.date,
        'mood': journal.mood,
        'note': journal.note,
        'uid': journal.uid,
      });
      return _documentReference.id.isNotEmpty;
    } catch (e) {
      print('Error adding journal: $e');
      return false;
    }
  }

  Future<void> updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((error) => print('Error updating: $error'));
  }

  Future<void> updateJournalWithTransaction(Journal journal) async {
    DocumentReference _documentReference =
        _firestore.collection(_collectionJournals).doc(journal.documentID);
    var journalData = {
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    };
    try {
      await _firestore.runTransaction((transaction) async {
        transaction.set(
            _documentReference, journalData); // Use set instead of update
      });
    } catch (error) {
      print('Error updating: $error');
      throw error; // Rethrow the error after printing
    }
  }

  Future<void> deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }
}
