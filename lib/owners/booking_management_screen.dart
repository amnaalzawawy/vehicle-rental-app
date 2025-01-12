import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/car.dart';
import 'package:untitled2/owners/booking_managment_card.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';

class BookingManagementPage extends StatefulWidget {
  const BookingManagementPage({super.key});

  @override
  State<BookingManagementPage> createState() => _BookingManagementPageState();
}

class _BookingManagementPageState extends State<BookingManagementPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      UserProvider().getCurrentUser().then((user) {
        var querySnapshot = _firestore.collection('cars');
          querySnapshot.where("owner", isEqualTo: user!.userId).get().then(
            (value) {
              var _cars = value.docs
                  .map((doc) => CarModel.fromMap(doc.data(), doc.id))
                  .toList();

              final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
              var carsIDs = _cars.map((e) => e.id).toList();
              if (carsIDs.isNotEmpty) {
                bookingProvider.fetchBookingsForCars(carsIDs);
              }
            },
          );
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة الحجوزات"),
      ),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingProvider.bookings.isEmpty
              ? const Center(child: Text("لا توجد حجوزات حاليًا"))
              : ListView.builder(
                  itemCount: bookingProvider.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingProvider.bookings[index];

                    return BookingManagmentCard(booking: booking);
                  },
                ),
    );
  }
}
