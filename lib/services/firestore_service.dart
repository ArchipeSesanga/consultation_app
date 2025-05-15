/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get studentsRef => _db.collection('students');
  CollectionReference get adminsRef => _db.collection('admins');

  // Save student data (uses uid as document ID)
  Future<void> saveStudentData({
    required String uid,
    required String studentId,
    required String email,
    required String contact,
  }) async {
    await studentsRef.doc(uid).set({
      'studentId': studentId,
      'email': email,
      'contact': contact,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get student by UID
  Future<DocumentSnapshot> getStudentByUid(String uid) async {
    return await studentsRef.doc(uid).get();
  }

  // Update student by UID
  Future<void> updateStudent({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await studentsRef.doc(uid).update(data);
  }

  // Delete student by UID
  Future<void> deleteStudent(String uid) async {
    await studentsRef.doc(uid).delete();
  }

  // Save admin data (uses uid as document ID)
  Future<void> saveAdminData({
    required String uid,
    required String email,
    required String name,
  }) async {
    await adminsRef.doc(uid).set({
      'email': email,
      'name': name,
      'role': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get admin by UID
  Future<DocumentSnapshot> getAdminByUid(String uid) async {
    return await adminsRef.doc(uid).get();
  }

  // Update admin by UID
  Future<void> updateAdmin({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await adminsRef.doc(uid).update(data);
  }

  // Delete admin by UID
  Future<void> deleteAdmin(String uid) async {
    await adminsRef.doc(uid).delete();
  }
}
