import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountService {

  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool hasUser = false;

  String? currentUserId;

  AccountService() {
    hasUser = currentUser != null;
    currentUserId = currentUser?.uid;
  }

  Future<UserCredential?> logIn(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signUp(String userName, String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}