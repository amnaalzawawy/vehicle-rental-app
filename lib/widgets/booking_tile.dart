import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final Function()? onDelete;
  final Function()? onEdit;

  BookingTile({required this.booking, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(booking.userName ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${booking.vehicleDetails}'),
            Text('Start Date: ${booking.startDate?.toLocal()}'),
            Text('End Date: ${booking.endDate?.toLocal()}'),
            Text('Status: ${booking.status}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
