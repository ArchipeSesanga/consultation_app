/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final _firestoreService = FirestoreService();

  // Register user
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password, String trim,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      debugPrint("Registration error: $e");
    }
    return null;
  }

  // Login user
  Future<User?> logUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      debugPrint("Login error: $e");
    }
    return null;
  }

  // Admin login
  Future<User?> logAdminWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // You may want to check if the user is an admin in Firestore here
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Optionally: check admin role in Firestore
      return cred.user;
    } catch (e) {
      debugPrint("Admin login error: $e");
    }
    return null;
  }

  // Register admin
  Future<User?> createAdminWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save admin role in Firestore
      await FirebaseFirestore.instance.collection('admins').doc(cred.user!.uid).set({
        'email': email,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return cred.user;
    } catch (e) {
      debugPrint("Admin registration error: $e");
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Sign out error: $e");
    }
  }

  register(String trim, String trim2, {required String email}) {}

  login(String trim, String trim2) {}
  
}
