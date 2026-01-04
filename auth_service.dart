import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 🔹 Google Authentication
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      // user cancelled login
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential =
      GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // ✅ Single & correct sign-in
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      log("Google Sign-In Error: $e");
      return null;
    }
  }

  /// 🔹 Create user with email & password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
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

  /// 🔹 Login user with email & password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
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

  /// 🔹 Sign out user
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Google logout
      await _auth.signOut();        // Firebase logout
    } catch (e) {
      log("Sign out Error: $e");
    }
  }
}

