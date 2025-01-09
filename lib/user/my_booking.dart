import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom_user_drawer.dart';
import 'edit_booking.dart'; // واجهة تعديل الحجز

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Booking> books = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        UserProvider().getCurrentUser().then(
              (user) {
            print("Getting bookings for user....");
            print(user?.userId ?? "NONE");
            if (user != null) {
              Provider.of<BookingProvider>(context, listen: false)
                  .fetchBookings(user.userId);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<BookingProvider>();
    var bookings = provider.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حجوزاتي'),
      ),
      drawer: CustomDrawer2(),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        child: const Text(
                          'حذف الحجز',
                          style: TextStyle(color: Colors.white), // تغيير لون النص إلى الأبيض
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // تغيير لون الخلفية إلى الأحمر
                        ),
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
        },
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
            Text('النوع: ${booking.carId}'),
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
