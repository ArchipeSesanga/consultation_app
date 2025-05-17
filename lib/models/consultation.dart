/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Consultation {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String description;
  final String topic;
  final Lecturer lecturer;
  final String studentId;
  final String status; // 'pending' or 'confirmed'

  Consultation({
    required this.id,
    required this.date,
    required this.time,
    required this.description,
    required this.topic,
    required this.lecturer,
    required this.studentId,
    this.status = 'pending', // default status is 'pending'
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'timeHour': time.hour,
      'timeMinute': time.minute,
      'description': description,
      'topic': topic,
      'lecturer': lecturer.toMap(),
      'studentId': studentId,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Factory constructor to create a Consultation object from a Firestore document
  /// This is useful when retrieving data from Firestore.
  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      date: map['date'],

      time: TimeOfDay(hour: map['timeHour'], minute: map['timeMinute']),
      description: map['description'],
      topic: map['topic'],
      lecturer: Lecturer.fromMap(map['lecturer']),
      studentId: map['studentId'],
      status: map['status'] ?? 'pending',
    );
  }
}
