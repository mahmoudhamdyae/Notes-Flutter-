import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/account_service.dart';

class FirebaseService {

  AccountService accountService = AccountService();
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  Future getNotes() async {
    return await notesRef.where("userId", isEqualTo: accountService.currentUserId).get();
  }

  Future addNote(String? title, String? note, String? imageUrl) async {
    return await notesRef.add({
      "title": title,
      "note": note,
      "imageUrl": imageUrl,
      "userId": accountService.currentUserId
    });
  }

  Future<void> delNote(String noteId) async {
    return notesRef.doc(noteId).delete();
  }

  Future updateNote(String noteId, String? title, String? note, String? imageUrl) async {
    if (imageUrl == null) {
      return await notesRef.doc(noteId).update({
        "title": title,
        "note": note,
      });
    } else {
      return await notesRef.doc(noteId).update({
        "title": title,
        "note": note,
        "imageUrl": imageUrl,
      });
    }
  }
}