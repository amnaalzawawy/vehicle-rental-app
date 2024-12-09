import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';

class AddBookingScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _vehicleDetailsController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Booking'),
        backgroundColor: Color(0xFFF78B00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value!.isEmpty ? 'Please enter the customer name' : null,
              ),
              TextFormField(
                controller: _vehicleDetailsController,
                decoration: InputDecoration(labelText: 'Vehicle Details'),
                validator: (value) => value!.isEmpty ? 'Please enter the vehicle details' : null,
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Please enter the end date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final booking = Booking(
                      id: '', // سيتم توليد ID عند الإضافة إلى Firestore
                      userName: _customerNameController.text,
                      vehicleDetails: _vehicleDetailsController.text,
                      startDate: DateTime.parse(_startDateController.text),
                      endDate: DateTime.parse(_endDateController.text),
                      status: 'Pending',
                      createdAt: DateTime.now(),
                    );

                    if (booking.startDate.isAfter(booking.endDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Start date must be before end date.')),
                      );
                      return;
                    }

                    Provider.of<BookingProvider>(context, listen: false).addBooking(booking);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
