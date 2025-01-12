import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final Function()? onDelete;
  final Function()? onEdit;

  const BookingTile({super.key, required this.booking, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
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
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
