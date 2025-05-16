import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> createAdminWithEmailAndPassword(
  String email,
  String password,
  String name, // include name
) async {
  try {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Save admin info in Firestore
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(cred.user!.uid)
        .set({
          'email': email,
          'name': name, // save name
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });
    return cred.user;
  } catch (e) {
    debugPrint("Admin registration error: $e");
    rethrow;
  }
}