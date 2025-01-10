import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../providers/booking_provider.dart';

class AddBookingScreen extends StatefulWidget {
  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String carName = '';
  String carCategory = '';
  String ownerName = '';
  String plateNumber = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String status = 'Pending'; // الوضع الافتراضي

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة حجز'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم العميل'),
                onSaved: (value) {
                  userName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال اسم العميل';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم السيارة'),
                onSaved: (value) {
                  carName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال اسم السيارة';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'فئة السيارة'),
                onSaved: (value) {
                  carCategory = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال فئة السيارة';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم المالك'),
                onSaved: (value) {
                  ownerName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال اسم المالك';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم اللوحة'),
                onSaved: (value) {
                  plateNumber = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال رقم اللوحة';
                  }
                  return null;
                },
              ),
              // استخدم DatePicker لاختيار التواريخ
              // على سبيل المثال، استخدام `showDatePicker` لاختيار startDate و endDate
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // إنشاء تفاصيل المركبة كـ Map
                    final vehicleDetails = {
                      'carName': carName,
                      'carCategory': carCategory,
                      'ownerName': ownerName,
                      'plateNumber': plateNumber,
                    };

                    // إنشاء الكائن الحجز مع بيانات المركبة
                    final booking = Booking(
                      id: '',
                      userName: userName,
                      vehicleDetails: vehicleDetails,
                      startDate: startDate,
                      endDate: endDate,
                      status: status,
                      createdAt: DateTime.now(), ownerName: '',
                    );

                    // تم تمرير `userId` إلى الدالة
                    await bookingProvider.addBooking(booking, 'userId'); // تأكد من تم تمرير userId
                    Navigator.pop(context);
                  }
                },
                child: Text('إضافة الحجز'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
