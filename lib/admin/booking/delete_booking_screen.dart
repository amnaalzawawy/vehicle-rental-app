/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';


class DeleteBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Booking'),
        backgroundColor: Color(0xFFF78B00),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return ListView.builder(
            itemCount: bookingProvider.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingProvider.bookings[index];
              return ListTile(
                title: Text(booking.customerName),
                subtitle: Text(booking.vehicleDetails),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    bookingProvider.deleteBooking(booking.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/
