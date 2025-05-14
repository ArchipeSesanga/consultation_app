import 'dart:math';

import 'package:assignement_1_2025/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestoreService = FirestoreService();

  Future<User?> CreateUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try{
       final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
    } catch (e) {
      debugPrint("Something went wrong");
     
    }
    return null;
  }


  Future<User?> logUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try{
       final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
    } catch (e) {
      debugPrint("Something went wrong");
     
    }
    return null;
  }    

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Something went wrong");
    }
  }      
}
 