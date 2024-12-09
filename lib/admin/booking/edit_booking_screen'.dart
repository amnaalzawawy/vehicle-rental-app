import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
/*
class EditBookingScreen extends StatefulWidget {
  final String bookingId;
  EditBookingScreen({required this.bookingId});

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  late Booking _booking;

  @override
  void initState() {
    super.initState();
    _booking = Provider.of<BookingProvider>(context, listen: false).findById(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
        backgroundColor: Color(0xFFF78B00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _booking.customerName,
                decoration: InputDecoration(labelText: 'Customer Name'),
                onChanged: (value) => _booking.customerName = value,
              ),
              TextFormField(
                initialValue: _booking.vehicleDetails,
                decoration: InputDecoration(labelText: 'Vehicle Details'),
                onChanged: (value) => _booking.vehicleDetails = value,
              ),
              TextFormField(
                initialValue: _booking.startDate.toString(),
                decoration: InputDecoration(labelText: 'Start Date'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) => _booking.startDate = DateTime.parse(value),
              ),
              TextFormField(
                initialValue: _booking.endDate.toString(),
                decoration: InputDecoration(labelText: 'End Date'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) => _booking.endDate = DateTime.parse(value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<BookingProvider>(context, listen: false).updateBooking(_booking);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/