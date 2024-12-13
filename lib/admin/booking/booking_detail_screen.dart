import 'package:flutter/material.dart';

import '../../models/booking.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  BookingDetailScreen({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: ${booking.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'User Name: ${booking.userName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Vehicle Details: ${booking.vehicleDetails}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Start Date: ${booking.startDate?.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'End Date: ${booking.endDate?.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${booking.status}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Created At: ${booking.createdAt?.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back to Bookings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
