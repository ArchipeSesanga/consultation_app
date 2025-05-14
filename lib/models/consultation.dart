/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String description;
  final String topic;
  final Lecturer lecturer;
  final String studentId;

  Consultation({
    required this.id,
    required this.date,
    required this.time,
    required this.description,
    required this.topic,
    required this.lecturer,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': Timestamp.fromDate(
        date,
      ), // Convert DateTime to Firestore Timestamp
      'timeHour': time.hour, // Store hour component of TimeOfDay
      'timeMinute': time.minute, // Store minute component of TimeOfDay
      'description': description,
      'topic': topic,
      'lecturer': lecturer.toMap(), // Convert Lecturer object to map
      'studentId': studentId,
      'createdAt': FieldValue.serverTimestamp(), // Add server timestamp
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      date:
          (map['date'] as Timestamp)
              .toDate(), // Convert Timestamp back to DateTime
      time: TimeOfDay(
        hour: map['timeHour'],
        minute: map['timeMinute'],
      ), // Reconstruct TimeOfDay
      description: map['description'],
      topic: map['topic'],
      lecturer: Lecturer.fromMap(
        map['lecturer'],
      ), // Convert map back to Lecturer
      studentId: map['studentId'],
    );
  }
}
