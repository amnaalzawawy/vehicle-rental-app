import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';

class BookingManagementPage extends StatelessWidget {
  const BookingManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة الحجوزات"),
      ),
      body: bookingProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingProvider.bookings.isEmpty
          ? Center(child: Text("لا توجد حجوزات حاليًا"))
          : ListView.builder(
        itemCount: bookingProvider.bookings.length,
        itemBuilder: (context, index) {
          final booking = bookingProvider.bookings[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(booking.vehicleDetails ?? "تفاصيل المركبة غير متوفرة"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("العميل: ${booking.userName ?? "غير معروف"}"),
                  Text("من: ${booking.startDate?.toLocal() ?? "غير محدد"}"),
                  Text("إلى: ${booking.endDate?.toLocal() ?? "غير محدد"}"),
                  Text("الحالة: ${booking.status ?? "غير معروف"}"),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'confirm') {
                    await bookingProvider.updateBooking(booking.id!, {'status': 'Confirmed'});
                  } else if (value == 'complete') {
                    await bookingProvider.updateBooking(booking.id!, {'status': 'Completed'});
                  } else if (value == 'cancel') {
                    await bookingProvider.updateBooking(booking.id!, {'status': 'Cancelled'});
                  } else if (value == 'delete') {
                    await bookingProvider.deleteBooking(booking.id!);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'confirm', child: Text('تأكيد الحجز')),
                  PopupMenuItem(value: 'complete', child: Text('إكمال الحجز')),
                  PopupMenuItem(value: 'cancel', child: Text('إلغاء الحجز')),
                  PopupMenuItem(value: 'delete', child: Text('حذف الحجز')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
