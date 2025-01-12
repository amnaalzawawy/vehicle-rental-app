import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/booking.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/current_user_provider.dart';

class BookingManagementCard extends StatefulWidget {
  final Booking booking;

  const BookingManagementCard({super.key, required this.booking});

  @override
  State<BookingManagementCard> createState() => _BookingManagementCardState();
}

class _BookingManagementCardState extends State<BookingManagementCard> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    // الحصول على بيانات المستخدم إذا كانت موجودة
    if (widget.booking.userId != null) {
      UserProvider().getUser(widget.booking.userId!).then((value) {
        setState(() {
          user = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookingProvider = Provider.of<BookingProvider>(context);
    var outputFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.booking.vehicleDetails != null
            ? widget.booking.vehicleDetails!["name"] ?? "تفاصيل المركبة غير متوفرة"
            : "تفاصيل المركبة غير متوفرة"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("العميل: ${user?.firstName ?? "غير معروف"}"),
            Text("من: ${outputFormat.format(widget.booking.startDate!.toLocal())}"),
            Text("إلى: ${outputFormat.format(widget.booking.endDate!.toLocal())}"),
            Text("الحالة: ${widget.booking.status ?? "غير معروف"}"),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
              if (value == 'cancel') {
              await bookingProvider.updateBooking(
                  widget.booking.id!, {'status': 'Cancelled'}
              );
           } else
        if (value == 'delete') {
              await bookingProvider.deleteBooking(widget.booking.id!);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'cancel', child: Text('إلغاء الحجز')),
            const PopupMenuItem(value: 'delete', child: Text('حذف الحجز')),
          ],
        ),
      ),
    );
  }
}
