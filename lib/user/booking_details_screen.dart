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

  // دالة لاختيار تاريخ البداية
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

  // دالة لاختيار تاريخ النهاية
  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  // دالة للتحقق من تعارض الحجز
  Future<bool> _checkBookingConflict(DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _firestore.collection('bookings')
        .where('carId', isEqualTo: widget.car.id)
        .get();

    for (var doc in querySnapshot.docs) {
      DateTime bookedStartDate = (doc['startDate'] as Timestamp).toDate();
      DateTime bookedEndDate = (doc['endDate'] as Timestamp).toDate();

      // التحقق من التداخل بين الحجزين
      if ((startDate.isBefore(bookedEndDate) && endDate.isAfter(bookedStartDate)) ||
          (startDate.isAtSameMomentAs(bookedStartDate) || endDate.isAtSameMomentAs(bookedEndDate))) {
        return true;
      }
    }
    return false;
  }

  // دالة لحفظ الحجز
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

    // التحقق من تعارض الحجز
    bool conflict = await _checkBookingConflict(_startDate!, _endDate!);
    if (conflict) {
      setState(() {
        _errorMessage = 'هذه المركبة محجوزة في هذه الفترة';
      });
      return;
    }

    // إضافة الحجز إلى قاعدة البيانات
    await _firestore.collection('bookings').add({
      'carId': widget.car.id,
      'userId': 'userID', // يتم تحديده بناءً على المستخدم الحالي
      'startDate': Timestamp.fromDate(_startDate!),
      'endDate': Timestamp.fromDate(_endDate!),
      'status': 'مؤكد', // أو حسب الحالة المناسبة
    });

    setState(() {
      _errorMessage = null; // إعادة تعيين رسالة الخطأ عند الحجز بنجاح
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم الحجز بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الحجز'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض بيانات المركبة
            Text('اسم المركبة: ${widget.car.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('الفئة: ${widget.car.category}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('اسم الشركة المالكة: ${widget.car.ownerName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('السعر اليومي: ${widget.car.pricePerDay} ل.س', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),

            // اختيار تاريخ البداية
            Text('تاريخ البداية: ${_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'لم يتم تحديده'}'),
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              child: Text('اختيار تاريخ البداية'),
            ),
            SizedBox(height: 10),

            // اختيار تاريخ النهاية
            Text('تاريخ النهاية: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'لم يتم تحديده'}'),
            ElevatedButton(
              onPressed: () => _selectEndDate(context),
              child: Text('اختيار تاريخ النهاية'),
            ),
            SizedBox(height: 20),

            // عرض رسالة الخطأ إذا كانت هناك مشكلة
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            SizedBox(height: 20),

            // زر الحجز
            ElevatedButton(
              onPressed: _saveBooking,
              child: Text('تأكيد الحجز'),
            ),
          ],
        ),
      ),
    );
  }
}
