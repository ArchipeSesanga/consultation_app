/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consultation.dart';
//import '../models/lecturer.dart';

class ConsultationViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'consultations';

  // In-memory cache of consultations
  final List<Consultation> _consultations = [];
  List<Consultation> get consultations => _consultations;

  // Constructor to initialize and load data
  ConsultationViewModel() {
    loadConsultations();
  }

  // Load consultations from Firestore
  Future<void> loadConsultations() async {
    try {
      // Clear the existing list
      _consultations.clear();

      // Get consultations from Firestore, ordered by date (newest first)
      final QuerySnapshot snapshot =
          await _firestore
              .collection(_collectionPath)
              .orderBy('date', descending: true)
              .get();

      // Convert each document to a Consultation object
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _consultations.add(Consultation.fromMap(data));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading consultations: $e');
    }
  }

  // Add a new consultation to Firestore
  Future<void> addConsultation(Consultation consultation) async {
    try {
      // Add to Firestore
      await _firestore
          .collection(_collectionPath)
          .doc(consultation.id)
          .set(consultation.toMap());

      // Add to local cache
      _consultations.add(consultation);

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding consultation: $e');
      throw Exception('Failed to add consultation: $e');
    }
  }

  // Get consultations for a specific student
  Future<List<Consultation>> getStudentConsultations(String studentId) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection(_collectionPath)
              .where('studentId', isEqualTo: studentId)
              .orderBy('date', descending: true)
              .get();

      return snapshot.docs
          .map(
            (doc) => Consultation.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      debugPrint('Error getting student consultations: $e');
      return [];
    }
  }

  // Delete a consultation by id
  Future<void> deleteConsultation(String id) async {
    try {
      // Delete from Firestore
      await _firestore.collection(_collectionPath).doc(id).delete();

      // Remove from local cache
      _consultations.removeWhere((consultation) => consultation.id == id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting consultation: $e');
      throw Exception('Failed to delete consultation: $e');
    }
  }
}
