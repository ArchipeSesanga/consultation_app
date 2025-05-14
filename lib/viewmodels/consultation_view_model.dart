/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consultation.dart';

class ConsultationViewModel with ChangeNotifier {
  // In-memory list to hold consultations
  final List<Consultation> _consultations = [];
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Fetch consultations from Firestore

  List<Consultation> get consultations => _consultations;

  // Save to Firestore and local memory
  Future<void> addConsultation(Consultation consultation) async {
    try {
      await _firestore.collection('consultations').add(consultation.toMap());

      _consultations.add(consultation); // Add to list in memory
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print("Error adding consultation: $e");
    }
  }

  // Load consultations for logged-in student
  Future<void> loadConsultations(String studentId) async {
    final snapshot =
        await _firestore
            .collection('consultations')
            .where('studentId', isEqualTo: studentId)
            .orderBy('dateTime')
            .get();

    _consultations.clear(); // Clear existing consultations
    _consultations.addAll(
      snapshot.docs.map((doc) => Consultation.fromMap(doc.data())),
    );
    notifyListeners(); // Notify listeners to update UI
  }

  // Delete a consultation by id
  void deleteConsultation(String id) async {
    await _firestore.collection('consultations').doc(id).delete();
    _consultations.removeWhere((consultation) => consultation.id == id);
    notifyListeners(); // Notify listeners to update UI
  }
}
