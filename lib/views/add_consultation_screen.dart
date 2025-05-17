/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:assignement_1_2025/models/lecturer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/consultation.dart';
import '../viewmodels/consultation_view_model.dart';

class AddConsultationScreen extends StatefulWidget {
  final Consultation?
  consultation; // Optional parameter for editing existing consultation

  const AddConsultationScreen({super.key, this.consultation});

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
  bool _isLoading = false; // Added loading state
  bool _isEditing = false; // Flag to check if we're editing or creating
  String? _originalConsultationId; // To store original ID when editing

  // Status options (for the new requirement)
  String _consultationStatus = 'pending'; // Default status
  final List<String> _statusOptions = ['pending'];

  // List of lecturers that can be selected
  final List<Lecturer> _lecturers = [
    Lecturer(
      id: '1',
      name: 'Mr. L. Grobblaar',
      email: 'grobblaar@cut.ac.za',
      module: 'Software Development',
    ),
    Lecturer(
      id: '2',
      name: 'Mr Murrithi',
      email: 'murrithi@cut.ac.za',
      module: 'Technical Programming',
    ),
    Lecturer(
      id: '3',
      name: 'Ms. MJ. Mbele',
      email: 'mmbele@cut.ac.za',
      module: 'Technical Programming',
    ),
    Lecturer(
      id: '4',
      name: 'Dr. N. Mabanza',
      email: 'mabanza@cut.ac.za',
      module: 'Communication Networks',
    ),
    Lecturer(
      id: '5',
      name: 'Mr.A. Akanbi',
      email: 'aakanbi@cut.ac.za',
      module: 'Software Engineering',
    ),
  ];

  Lecturer? _selectedLecturer;

  @override
  // Initialize the selected lecturer
  void initState() {
    super.initState();

    // Check if we're editing an existing consultation
    if (widget.consultation != null) {
      _isEditing = true;
      _originalConsultationId = widget.consultation!.id;
      _topicController.text = widget.consultation!.topic;
      _descController.text = widget.consultation!.description;
      _selectedDate = widget.consultation!.date;
      _selectedTime = widget.consultation!.time;
      _consultationStatus =
          widget.consultation!.status ??
          'pending'; // Use the consultation status or default to pending

      // Find the lecturer that matches the one in the consultation
      _selectedLecturer = _lecturers.firstWhere(
        (lecturer) => lecturer.id == widget.consultation!.lecturer.id,
        orElse: () => _lecturers.first,
      );

      // Since we're populating all fields, the button should be enabled
      _disabled = false;
    }
  }

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
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Consultation' : 'Add Consultation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Add the formKey to the Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Select a Lecturer
                DropdownButtonFormField<Lecturer>(
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
                        return DropdownMenuItem<Lecturer>(
                          value: lecturer,
                          child: Text('${lecturer.module} - ${lecturer.name}'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedLecturer = value);
                    _SetDisabled();
                  },
                  validator:
                      (value) =>
                          value == null ? 'Please select a lecturer' : null,
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
                  onChanged: (_) => _SetDisabled(),
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

                const SizedBox(height: 20),
                // Status Dropdown (New)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  value: _consultationStatus,
                  items:
                      _statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status.capitalize()),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _consultationStatus = value);
                    }
                  },
                ),

                const SizedBox(height: 30),

                // Save Button
                Center(
                  child:
                      _isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : IgnorePointer(
                            ignoring: _disabled,
                            child: Opacity(
                              opacity:
                                  _disabled
                                      ? 0.5
                                      : 1.0, //Dim the button when disabled
                              child: ElevatedButton(
                                onPressed:
                                    _disabled
                                        ? null
                                        : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            try {
                                              setState(() => _isLoading = true);

                                              final description =
                                                  _descController.text;
                                              final topic =
                                                  _topicController.text;

                                              final user =
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser;
                                              final studentId =
                                                  user?.uid ?? 'unknown';

                                              // Create a new consultation object
                                              final consultation = Consultation(
                                                id:
                                                    _isEditing
                                                        ? _originalConsultationId!
                                                        : DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString(),
                                                description: description,
                                                topic: topic,
                                                date: _selectedDate,
                                                time: _selectedTime,
                                                lecturer: _selectedLecturer!,
                                                studentId: studentId,
                                                status: _consultationStatus,
                                              );

                                              final viewModel = Provider.of<
                                                ConsultationViewModel
                                              >(context, listen: false);

                                              if (_isEditing) {
                                                // Update existing consultation
                                                await viewModel
                                                    .updateConsultation(
                                                      consultation,
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Consultation updated successfully!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              } else {
                                                // Add new consultation
                                                await viewModel.addConsultation(
                                                  consultation,
                                                );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Consultation added successfully!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }

                                              // Navigate back to the previous screen
                                              Navigator.pop(context);
                                            } catch (e) {
                                              // Handle errors
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Error: Failed to save consultation. ${e.toString()}',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } finally {
                                              setState(
                                                () => _isLoading = false,
                                              );
                                            }
                                          }
                                        },
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
                                child: Text(
                                  _isEditing
                                      ? 'Update Consultation'
                                      : 'Save Consultation',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
  // Dispose the controllers
  void dispose() {
    _descController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void _SetDisabled() {
    setState(() {
      // Enable the button only if topic is not empty, description is not empty, and lecturer is selected
      _disabled =
          _topicController.text.isEmpty ||
          _descController.text.isEmpty ||
          _selectedLecturer == null;
    });
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
