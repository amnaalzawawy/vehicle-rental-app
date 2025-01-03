import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';

class BookingFormScreen extends StatefulWidget {
  final Booking? bookingToEdit;

  BookingFormScreen({this.bookingToEdit});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String userName;
  late String vehicleDetails;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    if (widget.bookingToEdit != null) {
      userName = widget.bookingToEdit!.userName!;
      vehicleDetails = widget.bookingToEdit!.vehicleDetails!;
      startDate = widget.bookingToEdit!.startDate!;
      endDate = widget.bookingToEdit!.endDate!;
    } else {
      userName = '';
      vehicleDetails = '';
      startDate = DateTime.now();
      endDate = DateTime.now().add(Duration(days: 1));
    }
  }

  // دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? DateTime.now();
    if (isStartDate) {
      setState(() {
        startDate = picked;
      });
    } else {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = 'userId'; // استبدلها بـ userId الحقيقي

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingToEdit != null ? 'Edit Booking' : 'Add Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: userName,
                decoration: InputDecoration(labelText: 'User Name'),
                onSaved: (value) => userName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: vehicleDetails,
                decoration: InputDecoration(labelText: 'Vehicle Details'),
                onSaved: (value) => vehicleDetails = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle details';
                  }
                  return null;
                },
              ),
              // اختيار التاريخ لبدء الحجز
              Row(
                children: [
                  Text('Start Date: ${startDate.toLocal()}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              // اختيار التاريخ لنهاية الحجز
              Row(
                children: [
                  Text('End Date: ${endDate.toLocal()}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newBooking = Booking(
                      id: widget.bookingToEdit?.id ?? '',
                      userName: userName,
                      vehicleDetails: vehicleDetails,
                      startDate: startDate,
                      endDate: endDate,
                      status: 'Pending',
                      createdAt: DateTime.now(),
                    );
                    if (widget.bookingToEdit == null) {
                      Provider.of<BookingProvider>(context, listen: false)
                          .addBooking(newBooking, userId); // تم تمرير userId هنا
                    } else {
                      Provider.of<BookingProvider>(context, listen: false)
                          .updateBooking(newBooking.id!, newBooking.toMap());
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.bookingToEdit != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
