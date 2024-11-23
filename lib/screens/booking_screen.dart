import 'package:flutter/material.dart';
import 'package:untitled2/models/booking.dart';
import 'package:untitled2/services/booking_service.dart';


class BookingScreen extends StatelessWidget {
  final String carId;
  final double totalAmount;
  final String userId;

  BookingScreen({required this.carId, required this.totalAmount, required this.userId});

  void _confirmBooking(BuildContext context) async {
    final booking = Booking(
      carId: carId,
      userId: userId,
      date: DateTime.now(),
      totalAmount: totalAmount,
    );

    await BookingService().addBooking(booking);

    // TODO: show notifications
    // await NotificationService().showNotification(
    //   'Booking Confirmed',
    //   'Your booking for $carId has been confirmed.',
    // );

    Navigator.pop(context);  // العودة إلى الشاشة السابقة بعد التأكيد
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: Column(
        children: [
          Text('Total Amount: \$${totalAmount.toString()}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _confirmBooking(context),
            child: Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
