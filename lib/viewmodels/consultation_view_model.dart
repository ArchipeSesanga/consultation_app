/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   S.P Vilane*/

import 'package:flutter/material.dart';
import '../models/consultation.dart';

class ConsultationViewModel with ChangeNotifier {
  // In-memory list to hold consultations
  final List<Consultation> _consultations = [];
  List<Consultation> get consultations => _consultations;

  // Add a new consultation to the list
  Future<void> addConsultation(Consultation consultation) async {
    _consultations.add(consultation); // Add to list in memory
    notifyListeners(); // Notify listeners to update UI
  }

  // Delete a consultation by id
  void deleteConsultation(String id) {
    _consultations.removeWhere((consultation) => consultation.id == id);
    notifyListeners(); // Notify listeners to update UI
  }
}
