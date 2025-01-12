


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/booking.dart';
import 'package:untitled2/models/car.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/car_provider.dart';

import 'edit_booking.dart';

class MyBookingCard extends StatefulWidget{
  Booking booking;

  MyBookingCard({ required this.booking, super.key});

  @override
  State<StatefulWidget> createState() {
    return MyBookingCardState();
  }

}


class MyBookingCardState extends State<MyBookingCard>{
  CarModel? car;
  @override
  void initState() {
    super.initState();
    if(widget.booking.carId != null) {
      Provider.of<CarProvider>(context).getCarById(widget.booking.carId!).then((value) {
      setState(() {
        car= value;
      });
    },);
    }
  }
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<BookingProvider>();
    var booking = widget.booking;
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اسم العميل: ${booking.userName}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('تفاصيل المركبة: ${booking.vehicleDetails}'),
            const SizedBox(height: 8),
            Text(
                'تاريخ الحجز: ${booking.startDate?.toLocal().toString().split(' ')[0]}'),
            Text(
                'تاريخ النهاية: ${booking.endDate?.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('الحالة: ${booking.status}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingEditScreen(booking: booking),
                      ),
                    );
                  },
                  child: const Text('تعديل الحجز'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await provider.deleteBooking(booking.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تم حذف الحجز بنجاح')),
                    );
                  },
                  child: const Text('حذف الحجز'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                _showCarDetails(context, booking);
              },
              child: const Text('المزيد من التفاصيل'),
            ),
          ],
        ),
      ),
    );
  }



  void _showCarDetails(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل المركبة'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تفاصيل المركبة: ${booking.vehicleDetails}'),
            const SizedBox(height: 8),
            Text('النوع: ${car?.fuelType ?? ""}'),
            // قم بتغيير هذا بناءً على بيانات المركبة المتوفرة
            const SizedBox(height: 8),
            Text('اسم الشركة المالكة: ${booking.userName}'),
            // مثال على بيانات أخرى
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

}