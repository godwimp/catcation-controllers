import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthController {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  
  User? get user => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }
// User sign in with email
  Future<User?> signInWithEmailAndPassword({required String email, required String password}) {
    if (!_validateEmail(email)) {
      return Future.error(Exception('Invalid email'));
    }
    if (password.isEmpty) {
      return Future.error(Exception('Password must not be empty.'));
    }
    if (email.isEmpty) {
      return Future.error(Exception('Email must not be empty.'));
    }
    try {
      final userCredential = _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.then((value) => value.user);
    } on PlatformException catch (e) {
      return Future.error(Exception(e.message));
    }
  }
  
// User regiter with email
  Future<User?> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      if (!_validateEmail(email)) {
        throw Exception('Invalid email');
      }
      if (password.isEmpty) {
        return null;
      }
      if (email.isEmpty) {
        return null;
      }
      if (password.length < 6) {
        return null;
      }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'role': 'catowner',
      });
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
// User update profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return;
      }
      final userCredential = EmailAuthProvider.credential(email: user.email!, password: password!);
      await user.reauthenticateWithCredential(userCredential);
      if (name != null && name != user.displayName) {
        await user.updateDisplayName(name);
      }
      if (email != null && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }
      await user.updatePassword(password);
        } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}

