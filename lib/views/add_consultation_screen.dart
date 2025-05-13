/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _disabled = true; //button disabled by default
  final List<String> _lecturers = [
    'Mr. L. Grobblaar',
    'Mr. Murrithi',
    'Dr. N. Mabanza',
    'Mr. A. Akanbi',
    'Mrs. M. Mbele',
  ];
  String? _selectedLecturer;

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

    if (picked != null) {
      final now = DateTime.now();

      // Combine selected date and picked time
      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        picked.hour,
        picked.minute,
      );

      if (_selectedDate.day == now.day &&
          _selectedDate.month == now.month &&
          _selectedDate.year == now.year &&
          selectedDateTime.isBefore(now)) {
        // Show warning if selected time is in the past
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a future time.'),
            backgroundColor: Colors.redAccent,
          ), // Show a warning if the selected time is in the past
        );
        return;
      }

      setState(() => _selectedTime = picked);
    }
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
                //Select a Lecturer
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Lecturer',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  value: _selectedLecturer,
                  items:
                      _lecturers.map((lecturer) {
                        return DropdownMenuItem<String>(
                          value: lecturer,
                          child: Text(lecturer),
                        );
                      }).toList(),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please select a lecturer'
                              : null,
                  onChanged: (value) {
                    setState(() {
                      _selectedLecturer = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

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
                // Topic Text Field
                TextFormField(
                  controller: _topicController,
                  onChanged: (text) {
                    _SetDisabled();
                  },
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Topic is required';
                    } else if (text.length < 20) {
                      return 'Topic must be at least 20 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),
                // Description Text Field
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
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
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Description is required'
                              : null,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 30),

                // Save Button
                Center(
                  child: IgnorePointer(
                    ignoring: _disabled,
                    child: Opacity(
                      opacity:
                          _disabled ? 0.5 : 1.0, //Dim the button when disabled
                      child: ElevatedButton(
                        onPressed:
                            _disabled
                                ? null
                                : () async {
                                  print("Button pressed");

                                  if (_formKey.currentState!.validate()) {
                                    print('Form is valid');

                                    final description = _descController.text;
                                    final topic = _topicController.text;

                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    final studentId = user?.uid ?? 'unknown';

                                    final consultation = Consultation(
                                      id:
                                          DateTime.now().millisecondsSinceEpoch
                                              .toString(),
                                      date: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(_selectedDate),
                                      time: _selectedTime.format(context),
                                      description: description,
                                      topic: topic,
                                      lecturer:
                                          _selectedLecturer ??
                                          '', // Ensure this is not null
                                      studentId: studentId,
                                    );

                                    // Save the consultation information using the view model
                                    await Provider.of<ConsultationViewModel>(
                                      context,
                                      listen: false,
                                    ).addConsultation(consultation);

                                    // Show a success snack bar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Consultation added successfully!',
                                        ),
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
                            fontSize:
                                18, // Larger text size for better readability
                            fontWeight:
                                FontWeight.bold, // Bold text for emphasis
                          ),
                        ),
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

  void _SetDisabled() {
    if (_topicController.text.isNotEmpty) {
      setState(() {
        _disabled = false; // Enable the button
      });
    } else {
      setState(() {
        _disabled = true; // Disable the button
      });
    }
  }
}
