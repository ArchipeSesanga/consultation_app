//import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String studentId;
  final String email;
  final String password;
  final String contactNumber;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.studentId,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.createdAt,
  });

  // Factory constructor to create a Student instance from a Firestore document
 // factory Student.fromFirestore(DocumentSnapshot doc) {
 //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
   // return Student(
    //  id: doc.id,
     // studentId: data['studentId'],
      //email: data['email'],
      //password: data['password'],
     // contactNumber: data['contactNumber'],
     // createdAt: (data['createdAt'] as Timestamp).toDate(),
   // );
 // }

  // Convert a Student instance to a Firestore-friendly Map
 // Map<String, dynamic> toFirestore() {
   // return {
    //  'studentId': studentId,
     // 'email': email,
     // 'password': password,
     // 'contactNumber': contactNumber,
     // 'createdAt': createdAt,
   // };
 // }
}
