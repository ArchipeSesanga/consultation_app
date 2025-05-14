import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../viewmodels/booking_view_model.dart';

class HomeScreen extends StatelessWidget {
  final String studentName = 'Thabo'; // You can fetch this from ProfileViewModel later

  @override
  Widget build(BuildContext context) {
    final bookingViewModel = context.watch<BookingViewModel>();
    final bookings = bookingViewModel.bookings;

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: RefreshIndicator(
        onRefresh: () async => bookingViewModel.refreshBookings(), // Firestore later
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "Welcome back, $studentName!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            if (bookings.isEmpty)
              Center(child: Text("No bookings yet."))
            else
              ..._groupedByDate(bookings).entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ...entry.value.map((booking) => Card(
                          child: ListTile(
                            title: Text(booking.topic),
                            subtitle: Text(
                              "${booking.lecturer} • ${_formatDateTime(booking.dateTime)}",
                            ),
                            trailing: Chip(
                              label: Text(booking.status),
                              backgroundColor: booking.status == 'confirmed'
                                  ? Colors.green[200]
                                  : Colors.orange[200],
                            ),
                          ),
                        )),
                    SizedBox(height: 10),
                  ],
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addBooking'); // Update route as needed
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Map<String, List<Booking>> _groupedByDate(List<Booking> bookings) {
    Map<String, List<Booking>> grouped = {};
    for (var booking in bookings) {
      final key =
          "${booking.dateTime.year}-${booking.dateTime.month.toString().padLeft(2, '0')}-${booking.dateTime.day.toString().padLeft(2, '0')}";
      grouped.putIfAbsent(key, () => []).add(booking);
    }
    return grouped;
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
