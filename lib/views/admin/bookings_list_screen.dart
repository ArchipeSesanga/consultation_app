import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assignement_1_2025/models/consultation.dart';
import 'package:assignement_1_2025/models/lecturer.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchStudentId = '';
  final String _collectionPath =
      'consultations'; // Changed from 'bookings' to 'consultations'

  // Helper to pick a date
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isStart
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Helper to update consultation status
  Future<void> _updateConsultationStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(_collectionPath)
          .doc(docId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Status updated to $newStatus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    }
  }

  // Delete booking with confirmation
  Future<void> _deleteBooking(String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Consultation'),
            content: const Text(
              'Are you sure you want to delete this consultation?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection(_collectionPath)
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Consultation deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Consultations'),
        backgroundColor: const Color(0xFF205759),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Start Date
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      child: Text(
                        _startDate == null
                            ? 'Any'
                            : DateFormat('yyyy-MM-dd').format(_startDate!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // End Date
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'End Date'),
                      child: Text(
                        _endDate == null
                            ? 'Any'
                            : DateFormat('yyyy-MM-dd').format(_endDate!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Search by Student ID
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchStudentId = val.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Consultations List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection(_collectionPath)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No consultations found.'));
                }

                try {
                  // Filter consultations
                  final consultations =
                      snapshot.data!.docs.where((doc) {
                        // Handle safely if doc.data() isn't properly typed
                        final data = doc.data();
                        if (data is! Map<String, dynamic>) {
                          return false; // Skip this document if it's not properly formatted
                        }

                        // Filter by studentId
                        if (_searchStudentId.isNotEmpty &&
                            (data['studentId'] ?? '')
                                    .toString()
                                    .toLowerCase() !=
                                _searchStudentId.toLowerCase()) {
                          return false;
                        }

                        // Filter by date range
                        if (_startDate != null || _endDate != null) {
                          // Handle the date in the document
                          DateTime? bookingDate;

                          if (data['date'] is Timestamp) {
                            bookingDate = (data['date'] as Timestamp).toDate();
                          } else if (data['date'] is DateTime) {
                            bookingDate = data['date'] as DateTime;
                          }

                          if (bookingDate != null) {
                            if (_startDate != null) {
                              final startDateOnly = DateTime(
                                _startDate!.year,
                                _startDate!.month,
                                _startDate!.day,
                              );
                              final bookingDateOnly = DateTime(
                                bookingDate.year,
                                bookingDate.month,
                                bookingDate.day,
                              );
                              if (bookingDateOnly.isBefore(startDateOnly))
                                return false;
                            }

                            if (_endDate != null) {
                              final endDateOnly = DateTime(
                                _endDate!.year,
                                _endDate!.month,
                                _endDate!.day,
                                23,
                                59,
                                59,
                              );
                              final bookingDateOnly = DateTime(
                                bookingDate.year,
                                bookingDate.month,
                                bookingDate.day,
                              );
                              if (bookingDateOnly.isAfter(endDateOnly))
                                return false;
                            }
                          }
                        }

                        return true;
                      }).toList();

                  if (consultations.isEmpty) {
                    return const Center(
                      child: Text('No consultations match your filters.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: consultations.length,
                    itemBuilder: (context, index) {
                      final doc = consultations[index];
                      final Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      String formattedDate = 'N/A';
                      TimeOfDay? timeOfDay;

                      // Handle date formatting
                      if (data['date'] is Timestamp) {
                        final dateTime = (data['date'] as Timestamp).toDate();
                        formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(dateTime);
                      } else if (data['date'] is DateTime) {
                        formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(data['date'] as DateTime);
                      }

                      // Handle time formatting
                      if (data['timeHour'] != null &&
                          data['timeMinute'] != null) {
                        timeOfDay = TimeOfDay(
                          hour: data['timeHour'],
                          minute: data['timeMinute'],
                        );
                      }

                      // Try to parse lecturer info
                      String lecturerName = 'N/A';
                      if (data['lecturer'] is Map<String, dynamic>) {
                        lecturerName =
                            (data['lecturer']
                                as Map<String, dynamic>)['name'] ??
                            'N/A';
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text('Topic: ${data['topic'] ?? 'N/A'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Student ID: ${data['studentId'] ?? 'N/A'}'),
                              Text('Lecturer: $lecturerName'),
                              Text('Status: ${data['status'] ?? 'pending'}'),
                              Row(
                                children: [
                                  Text('Date: $formattedDate'),
                                  const SizedBox(width: 10),
                                  if (timeOfDay != null)
                                    Text('Time: ${timeOfDay.format(context)}'),
                                ],
                              ),
                              if (data['description'] != null)
                                Text('Notes: ${data['description']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final currentStatus =
                                      (data['status'] ?? 'pending') as String;
                                  final newStatus =
                                      currentStatus == 'confirmed'
                                          ? 'pending'
                                          : 'confirmed';
                                  _updateConsultationStatus(doc.id, newStatus);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (data['status'] ?? 'pending') ==
                                              'confirmed'
                                          ? Colors.green
                                          : Colors.amber,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  (data['status'] ?? 'pending') == 'confirmed'
                                      ? 'Confirmed'
                                      : 'Pending',
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _deleteBooking(
                                      doc.id,
                                    ), // Fix function name
                                tooltip: 'Delete Consultation',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  return Center(child: Text('Error loading consultations: $e'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
