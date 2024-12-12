import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../providers/booking_provider.dart';

class AddBookingScreen extends StatelessWidget {
  // مفاتيح للنموذج والنصوص
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
          key: _formKey, // ربط النموذج بالمفتاح للتحقق من القيم
          child: Column(
            children: [
              // حقل إدخال اسم العميل
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value!.isEmpty ? 'Please enter the customer name' : null,
              ),
              // حقل إدخال تفاصيل المركبة
              TextFormField(
                controller: _vehicleDetailsController,
                decoration: InputDecoration(labelText: 'Vehicle Details'),
                validator: (value) => value!.isEmpty ? 'Please enter the vehicle details' : null,
              ),
              // حقل إدخال تاريخ البدء
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
              ),
              // حقل إدخال تاريخ الانتهاء
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Please enter the end date' : null,
              ),
              SizedBox(height: 20),
              // زر إضافة الحجز
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // محاولة تحليل التواريخ من النصوص
                      final startDate = DateTime.parse(_startDateController.text);
                      final endDate = DateTime.parse(_endDateController.text);

                      // التحقق من أن تاريخ البدء قبل تاريخ الانتهاء
                      if (startDate.isAfter(endDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Start date must be before end date.')),
                        );
                        return;
                      }

                      // إنشاء كائن الحجز
                      final booking = Booking(
                        id: '', // سيتم توليد ID عند الإضافة إلى Firestore
                        userName: _customerNameController.text,
                        vehicleDetails: _vehicleDetailsController.text,
                        startDate: startDate,
                        endDate: endDate,
                        status: 'Pending',
                        createdAt: DateTime.now(),
                      );

                      // استدعاء الدالة لإضافة الحجز
                      Provider.of<BookingProvider>(context, listen: false).addBooking(booking);

                      // الرجوع إلى الشاشة السابقة
                      Navigator.pop(context);
                    } catch (e) {
                      // معالجة الأخطاء عند تحليل التواريخ
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid date format. Use yyyy-MM-dd.')),
                      );
                    }
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
