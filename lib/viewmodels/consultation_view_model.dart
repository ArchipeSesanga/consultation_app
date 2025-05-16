/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   S.P Vilane*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/consultation.dart';

class ConsultationViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'bookings';

  // In-memory cache of consultations
  final List<Consultation> _consultations = [];
  List<Consultation> get consultations => _consultations;

  // Constructor to initialize and load data
  ConsultationViewModel() {
    loadConsultations();
  }

  // Load consultations from Firestore
  Future<void> loadConsultations() async {
    // Fetch consultations from Firestore for the current student
    // and update the `consultations` list, then notifyListeners();
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

  // Update an existing consultation
  Future<void> updateConsultation(Consultation consultation) async {
    try {
      // Update in Firestore
      await _firestore
          .collection(_collectionPath)
          .doc(consultation.id)
          .update(consultation.toMap());

      // Update in local cache
      final index = _consultations.indexWhere((c) => c.id == consultation.id);
      if (index != -1) {
        _consultations[index] = consultation;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating consultation: $e');
      throw Exception('Failed to update consultation: $e');
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

  // Get consultations grouped by date
  Map<String, List<Consultation>> getConsultationsGroupedByDate() {
    final Map<String, List<Consultation>> grouped = {};

    for (var consultation in _consultations) {
      final dateStr = DateFormat('yyyy-MM-dd').format(consultation.date);

      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }

      grouped[dateStr]!.add(consultation);
    }

    return grouped;
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

  // Find a consultation by ID
  Consultation? getConsultationById(String id) {
    try {
      return _consultations.firstWhere((consultation) => consultation.id == id);
    } catch (e) {
      return null;
    }
  }
}
