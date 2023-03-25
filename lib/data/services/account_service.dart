import 'package:firebase_auth/firebase_auth.dart';

class AccountService {

  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool hasUser = false;

  String? currentUserId;

  AccountService() {
    hasUser = currentUser != null;
    currentUserId = currentUser?.uid;
  }

  Future<void> logIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String userName, String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}