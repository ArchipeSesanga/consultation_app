/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/consultation.dart';
import '../viewmodels/consultation_view_model.dart';

class AddConsultationScreen extends StatefulWidget {
  const AddConsultationScreen({super.key});

  @override
  State<AddConsultationScreen> createState() => _AddConsultationScreenState();
}

class _AddConsultationScreenState extends State<AddConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _topicController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Select Date
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Select Time
  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Consultation')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Add the formKey to the Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Consultation Date',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Time Picker
                InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Consultation Time',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedTime.format(context)),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Description Text Field
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Consultation Description',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Description is required' : null,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Topic Text Field
                TextFormField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    labelText: 'Consultation Topic',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Topic is required' : null,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("Button pressed");

                      if (_formKey.currentState!.validate()) {
                        print('Form is valid');

                        final description = _descController.text;
                        final topic = _topicController.text;

                        final consultation = Consultation(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                          time: _selectedTime.format(context),
                          description: description,
                          topic: topic,
                        );

                        // Save the consultation information using the view model
                        await Provider.of<ConsultationViewModel>(context, listen: false)
                            .addConsultation(consultation);

                        // Show a success snack bar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Consultation added successfully!'),
                          ),
                        );

                        // Navigate back to the previous screen
                        Navigator.pop(context);
                      } else {
                        print('Form is not valid');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ), // Increased padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Rounded corners
                      ),
                      elevation: 5, // Subtle shadow effect
                    ),
                    child: const Text(
                      'Save Consultation',
                      style: TextStyle(
                        fontSize: 18, // Larger text size for better readability
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _topicController.dispose();
    super.dispose();
  }
}
