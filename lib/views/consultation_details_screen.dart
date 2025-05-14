/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/route_manager.dart';
import '../viewmodels/consultation_view_model.dart';


class ConsultationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> consultation;
  final Lecturer lecturer;

  const ConsultationDetailsScreen({super.key, required this.consultation, required this.lecturer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultation Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text('Name: ${lecturer.name}'),
            const SizedBox(height: 10),
            Text('Date: ${consultation['date']}'),
            const SizedBox(height: 10),
            Text('Time: ${consultation['time']}'),
            const SizedBox(height: 10),
            Text('Description: ${consultation['description']}'),
            const SizedBox(height: 10),
            Text('Topic: ${consultation['topic']}'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  // Show confirmation dialog before deletion
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Delete Consultation'),
                          content: const Text(
                            'Are you sure? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.pop(
                                    context,
                                  ), // Close the dialog
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Delete the consultation from the view model
                                Provider.of<ConsultationViewModel>(
                                  context,
                                  listen: false,
                                ).deleteConsultation(consultation['id']);

                                // Navigate to the HomeScreen after deletion using RouteManager
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteManager.homeScreen,
                                );
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                child: const Text(
                  'Delete Consultation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
