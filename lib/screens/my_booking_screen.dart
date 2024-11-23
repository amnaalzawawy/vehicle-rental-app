import 'package:flutter/material.dart';
import 'package:untitled2/models/booking.dart';
import 'package:untitled2/services/booking_service.dart';


class MyBookingsScreen extends StatefulWidget {
  final String userId; // يمكن تمرير userId من شاشة أخرى

  MyBookingsScreen({required this.userId});

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<Booking>> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = BookingService().getUserBookings(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Bookings")),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final bookings = snapshot.data;

          if (bookings == null || bookings.isEmpty) {
            return Center(child: Text("No bookings found"));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('Car ID: ${booking.carId}'),
                subtitle: Text('Date: ${booking.date.toString()}'),
                trailing: Text('\$${booking.totalAmount.toString()}'),
                onTap: () {
                  // يمكن إضافة تفاصيل إضافية عند النقر
                },
              );
            },
          );
        },
      ),
    );
  }
}
