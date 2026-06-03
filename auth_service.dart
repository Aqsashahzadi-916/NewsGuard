import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user with email and password
  Future<User?> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      final UserCredential cred =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      log("Signup Error: $e");
      return null;
    }
  }

  // Login user with email & password
  Future<User?> loginUserWithEmailAndPassword(String email,
      String password) async {
    try {
      final UserCredential cred =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      log("Login Error: $e");
      return null;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Sign out Error: $e");
    }
  }
}
