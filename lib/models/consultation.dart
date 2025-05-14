/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:flutter/material.dart';

class Consultation {
  final String id;
  final DateTime date; // Change to DateTime
  final TimeOfDay time; // Change to TimeOfDay
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
     required this.studentId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date, // Convert DateTime to string for storage
      'time': time, // Convert TimeOfDay to string for storage
      'description': description,
      'topic': topic,
      'lecturer' : lecturer,
      'studId': studentId
    };
  }
}
