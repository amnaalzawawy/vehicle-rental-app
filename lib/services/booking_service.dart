/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/models/booking.dart';

class BookingService {
  final  _db = FirebaseFirestore.instance;

  Future<void> addBooking(Booking booking) async {
    await _db.collection('bookings').add(booking.toMap());
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final snapshot = await _db.collection('bookings').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList();
  }
}*/


