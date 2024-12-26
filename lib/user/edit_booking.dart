import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // استيراد مكتبة لتنسيق التاريخ
import '../models/booking.dart';

class BookingEditScreen extends StatefulWidget {
  final Booking booking;

  BookingEditScreen({required this.booking});

  @override
  _BookingEditScreenState createState() => _BookingEditScreenState();
}

class _BookingEditScreenState extends State<BookingEditScreen> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.booking.startDate!));
    _endDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.booking.endDate!));
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _updateBooking() async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(widget.booking.id).update({
        'startDate': DateTime.parse(_startDateController.text),
        'endDate': DateTime.parse(_endDateController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تعديل الحجز بنجاح')));
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء تعديل الحجز')));
    }
  }

  // دالة لفتح منتقي التاريخ
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الحجز'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تاريخ البداية:'),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(hintText: 'اختار تاريخ البداية'),
              readOnly: true, // لجعل الحقل قابل للقراءة فقط
              onTap: () => _selectDate(context, _startDateController), // عند الضغط على الحقل، يفتح منتقي التاريخ
            ),
            SizedBox(height: 16),
            Text('تاريخ النهاية:'),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(hintText: 'اختار تاريخ النهاية'),
              readOnly: true, // لجعل الحقل قابل للقراءة فقط
              onTap: () => _selectDate(context, _endDateController), // عند الضغط على الحقل، يفتح منتقي التاريخ
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBooking,
              child: Text('تحديث الحجز'),
            ),
          ],
        ),
      ),
    );
  }
}
