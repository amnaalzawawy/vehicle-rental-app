
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final CarModel car;

  BookingScreen({required this.car});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // المتغيرات المطلوبة للحجز
  DateTime? _startDate;
  DateTime? _endDate;
  String? _errorMessage;

  // اختيار تاريخ البداية
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  // اختيار تاريخ النهاية
  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  // التحقق من تداخل الحجز
  Future<bool> _checkBookingConflict(DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _firestore
        .collection('bookings')
        .where('carId', isEqualTo: widget.car.id)
        .get();

    for (var doc in querySnapshot.docs) {
      DateTime bookedStartDate = (doc['startDate'] as Timestamp).toDate();
      DateTime bookedEndDate = (doc['endDate'] as Timestamp).toDate();

      if (startDate.isBefore(bookedEndDate) && endDate.isAfter(bookedStartDate)) {
        return true;
      }
    }
    return false;
  }

  // حفظ الحجز
  Future<void> _saveBooking() async {
    if (_startDate == null || _endDate == null) {
      setState(() {
        _errorMessage = 'يرجى تحديد تواريخ الحجز';
      });
      return;
    }

    if (_startDate!.isAfter(_endDate!)) {
      setState(() {
        _errorMessage = 'تاريخ البداية يجب أن يكون قبل تاريخ النهاية';
      });
      return;
    }

    bool conflict = await _checkBookingConflict(_startDate!, _endDate!);
    if (conflict) {
      setState(() {
        _errorMessage = 'هذه المركبة محجوزة في هذه الفترة';
      });
      return;
    }

    await _firestore.collection('bookings').add({
      'carId': widget.car.id,
      'userId':  FirebaseAuth.instance.currentUser!.uid,
      'startDate': Timestamp.fromDate(_startDate!),
      'endDate': Timestamp.fromDate(_endDate!),
      'status': 'مؤكد',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الحجز بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // العودة للخلف بعد الحجز
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الحجز'),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.date_range, color: Colors.orange),
                      title: Text(
                        'تاريخ البداية:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _startDate != null
                            ? DateFormat('yyyy-MM-dd').format(_startDate!)
                            : 'لم يتم تحديده',
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _selectStartDate(context),
                        child: Text('اختيار'),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.event, color: Colors.orange),
                      title: Text(
                        'تاريخ النهاية:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd').format(_endDate!)
                            : 'لم يتم تحديده',
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _selectEndDate(context),
                        child: Text('اختيار'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  'تأكيد الحجز',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: _saveBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}












