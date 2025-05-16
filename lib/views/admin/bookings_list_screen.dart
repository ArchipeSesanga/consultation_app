import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchStudentId = '';

  // Helper to pick a date
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
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

  // Delete booking with confirmation
  Future<void> _deleteBooking(String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('bookings').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Bookings')),
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
                      decoration: const InputDecoration(labelText: 'Start Date'),
                      child: Text(_startDate == null
                          ? 'Any'
                          : DateFormat('yyyy-MM-dd').format(_startDate!)),
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
                      child: Text(_endDate == null
                          ? 'Any'
                          : DateFormat('yyyy-MM-dd').format(_endDate!)),
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
          // Bookings List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }
                // Filter bookings
                final bookings = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  // Filter by studentId
                  if (_searchStudentId.isNotEmpty &&
                      (data['studentId'] ?? '').toString().toLowerCase() != _searchStudentId.toLowerCase()) {
                    return false;
                  }
                  // Filter by date range
                  if (_startDate != null || _endDate != null) {
                    if (data['dateTime'] is Timestamp) {
                      final bookingDate = (data['dateTime'] as Timestamp).toDate();
                      if (_startDate != null && bookingDate.isBefore(_startDate!)) return false;
                      if (_endDate != null && bookingDate.isAfter(_endDate!)) return false;
                    }
                  }
                  return true;
                }).toList();

                if (bookings.isEmpty) {
                  return const Center(child: Text('No bookings match your filters.'));
                }

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final doc = bookings[index];
                    final booking = doc.data() as Map<String, dynamic>;
                    String formattedDate = '';
                    if (booking['dateTime'] != null && booking['dateTime'] is Timestamp) {
                      final dateTime = (booking['dateTime'] as Timestamp).toDate();
                      formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text('Topic: ${booking['topic'] ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Student ID: ${booking['studentId'] ?? 'N/A'}'),
                            Text('Lecturer: ${booking['lecturer'] ?? 'N/A'}'),
                            // Status dropdown for admin
                            Row(
                              children: [
                                const Text('Status: '),
                                DropdownButton<String>(
                                  value: (booking['status'] ?? 'pending'), // lowercase
                                  items: const [
                                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                    DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                                  ],
                                  onChanged: (newStatus) async {
                                    if (newStatus != null && newStatus != booking['status']) {
                                      await FirebaseFirestore.instance
                                          .collection('bookings')
                                          .doc(doc.id)
                                          .update({'status': newStatus});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Status updated to $newStatus')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text('Date & Time: $formattedDate'),
                            Text('Notes: ${booking['notes'] ?? ''}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBooking(doc.id),
                          tooltip: 'Delete Booking',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}