import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get studentsRef => _db.collection('students');

  Future<void> saveStudent({
    required String studentId,
    required String email,
    required String contact,
  }) async {
    await studentsRef.doc(studentId).set({
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
