import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_drawer.dart';
import 'booking_form.dart';
import 'booking_detail_screen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedStatus = 'All'; // متغير لتحديد حالة الحجز
  DateTime? _selectedDate; // متغير لتحديد تاريخ الحجز

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    // فلترة الحجوزات حسب الحالة المختارة
    List<Booking> filteredBookings = _selectedStatus == 'All'
        ? bookingProvider.bookings
        : bookingProvider.bookings
        .where((booking) => booking.status == _selectedStatus)
        .toList();

    // فلترة الحجوزات حسب التاريخ المختار إذا تم تحديده
    if (_selectedDate != null) {
      filteredBookings = filteredBookings
          .where((booking) {
        // التحقق من أن startDate و endDate ليسا null
        if (booking.startDate != null && booking.endDate != null) {
          // استخدام toLocal() مع فحص التواريخ
          return booking.startDate!.toLocal().isAtSameMomentAs(_selectedDate!) ||
              booking.endDate!.toLocal().isAtSameMomentAs(_selectedDate!);
        }
        return false; // إذا كانت التواريخ null
      })
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingFormScreen(bookingToEdit: null),
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // فلترة حسب الحالة
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    items: [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed')),
                      DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    hint: Text('Select Status'),
                  ),
                ),
                SizedBox(width: 10),
                // فلترة حسب التاريخ
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: bookingProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (ctx, index) {
                final booking = filteredBookings[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Booking by: ${booking.userName}'),
                    subtitle: Text('Vehicle: ${booking.vehicleDetails}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingFormScreen(bookingToEdit: booking),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text('Are you sure you want to delete this booking?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              try {
                                await bookingProvider.deleteBooking(booking.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Booking deleted successfully')),
                                );
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error deleting booking')),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.green),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetailScreen(booking: booking),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
