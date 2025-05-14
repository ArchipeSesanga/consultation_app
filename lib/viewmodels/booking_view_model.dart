import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingViewModel extends ChangeNotifier {
  final List<Booking> _bookings = [
    Booking(
      id: '1',
      lecturer: 'Dr. Molefe',
      dateTime: DateTime.now().add(Duration(days: 1)),
      topic: 'Flutter Basics',
      status: 'pending',
    ),
    Booking(
      id: '2',
      lecturer: 'Prof. Moyo',
      dateTime: DateTime.now().add(Duration(days: 2)),
      topic: 'MVVM Architecture',
      status: 'confirmed',
    ),
  ];

  List<Booking> get bookings => _bookings;

  Future<void> refreshBookings() async {
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }


}
