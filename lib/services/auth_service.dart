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
    String password,
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

  // Register user with additional info
  Future<User?> registerUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user info in Firestore (optional, adjust collection as needed)
      await FirebaseFirestore.instance.collection('students').doc(cred.user!.uid).set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return cred.user;
    } catch (e) {
      debugPrint("User registration error: $e");
      rethrow;
    }
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
      // Check if user is in students collection
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(cred.user!.uid)
          .get();
      if (!doc.exists) {
        throw Exception('You are not registered as a student.');
      }
      return cred.user;
    } catch (e) {
      debugPrint("Login error: $e");
      rethrow;
    }
  }

  // Admin login
  Future<User?> logAdminWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Check if user is in admins collection
      final doc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(cred.user!.uid)
          .get();
      if (!doc.exists) {
        throw Exception('You are not registered as an admin.');
      }
      return cred.user;
    } catch (e) {
      debugPrint("Admin login error: $e");
      rethrow;
    }
  }

  // Register admin
  Future<User?> createAdminWithEmailAndPassword(
    String email,
    String password,
    String name, 
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save admin role and name in Firestore
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(cred.user!.uid)
          .set({
            'email': email,
            'name': name, 
            'role': 'admin',
            'createdAt': FieldValue.serverTimestamp(),
          });
      return cred.user;
    } catch (e) {
      debugPrint("Admin registration error: $e");
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Sign out error: $e");
    }
  }

  /*Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}*/
}
