 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:assignement_1_2025/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<String?> register({
    required String email,
    required String password,
    required String studentId,
    required String contact,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await _firestoreService.saveStudentData(
          uid: uid,
          studentId: studentId,
          email: email,
          contact: contact,
        );
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message; // error
    }
  }
}
