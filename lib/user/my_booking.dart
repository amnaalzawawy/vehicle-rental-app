import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom_user_drawer.dart';
import 'edit_booking.dart'; // واجهة تعديل الحجز

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حجوزاتي'),
      ),
      drawer: CustomDrawer2(),
      body:
      Consumer<BookingProvider>(builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (bookingProvider.bookings.isEmpty) {
            return Center(child: Text('لا يوجد لديك حجوزات حالياً.'));
          }

          return ListView.builder(
            itemCount: bookingProvider.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingProvider.bookings[index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسم العميل: ${booking.userName}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('تفاصيل المركبة: ${booking.vehicleDetails}'),
                      SizedBox(height: 8),
                      Text('تاريخ الحجز: ${booking.startDate?.toLocal().toString().split(' ')[0]}'),
                      Text('تاريخ النهاية: ${booking.endDate?.toLocal().toString().split(' ')[0]}'),
                      SizedBox(height: 8),
                      Text('الحالة: ${booking.status}'),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingEditScreen(booking: booking),
                                ),
                              );
                            },
                            child: Text('تعديل الحجز'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await bookingProvider.deleteBooking(booking.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم حذف الحجز بنجاح')),
                              );
                            },
                            child: Text('حذف الحجز'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          _showCarDetails(context, booking);
                        },
                        child: Text('المزيد من التفاصيل'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCarDetails(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل المركبة'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تفاصيل المركبة: ${booking.vehicleDetails}'),
            SizedBox(height: 8),
            Text('النوع: ${booking.carId}'),  // قم بتغيير هذا بناءً على بيانات المركبة المتوفرة
            SizedBox(height: 8),
            Text('اسم الشركة المالكة: ${booking.userName}'),  // مثال على بيانات أخرى
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
