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
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password).then((userCredential) {
          saveUserInDatabase(userName, email, password).then((value) {
            return userCredential;
          });
    });
    return null;
  }

  Future saveUserInDatabase(String userName, String email, String password) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .add({
      "userName": userName,
      "email": email
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}