/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  final String id;
  final String studentId; // Who submitted it
  final Lecturer lecturer; // Change to Lecturer type
  final DateTime dateTime; // combined date and time
  final String topic;
  final String description;

  Consultation({
    required this.id,
    required this.studentId,
    required this.lecturer,
    required this.dateTime,
    required this.topic,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'lecturer': lecturer.toMap(),
      'dateTime': dateTime, //firebase will automatically convert to timestamp
      'topic': topic,
      'description': description,
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      studentId: map['studentId'],
      lecturer: Lecturer.fromMap(map['lecturer']),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      topic: map['topic'],
      description: map['description'],
    );
  }
}
