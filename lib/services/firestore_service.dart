/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get studentsRef => _db.collection('students');

  Future<void> saveStudentData({
    required String uid,
    required String studentId,
    required String email,
    required String contact,
  }) async {
    await _db.collection('students').doc(uid).set({
      'studentId': studentId,
      'email': email,
      'contact': contact,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getStudentById(String studentId) async {
    return await studentsRef.doc(studentId).get();
  }

  Future<void> updateStudent({
    required String studentId,
    required Map<String, dynamic> data,
  }) async {
    await studentsRef.doc(studentId).update(data);
  }

  Future<void> deleteStudent(String studentId) async {
    await studentsRef.doc(studentId).delete();
  }
}
