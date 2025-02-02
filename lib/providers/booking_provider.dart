import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = []; // قائمة الحجوزات
  bool _isLoading = false; // حالة التحميل لتحديث واجهة المستخدم

  // Getter للوصول إلى حالة التحميل
  bool get isLoading => _isLoading;
  // Getter للوصول إلى قائمة الحجوزات
  List<Booking> get bookings => _bookings;

  Future<void> fetchBookings(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      // final userId = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId) // فلترة باستخدام userId
          .get();
      _bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      throw error;
    }
  }

  Future<void> fetchBookingsForCars(List<String> carsids) async {
    _isLoading = true;
    notifyListeners();
    try {

      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('carId', whereIn: carsids) // فلترة باستخدام userId
          .get();
      _bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      rethrow;
    }
  }

  // دالة لإضافة حجز جديد إلى قاعدة البيانات مع إنشاء معرف فريد للحجز
  Future<void> addBooking(Booking booking, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // إنشاء معرف فريد باستخدام UUID
      String bookingId = const Uuid().v4();

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set({
        'userId': userId, // إضافة userId
        'userName': booking.userName,
        'vehicleDetails': booking.vehicleDetails,
        'startDate': booking.startDate,
        'endDate': booking.endDate,
        'status': booking.status,
        'createdAt': booking.createdAt,
      });

      // إضافة الحجز إلى القائمة المحلية بعد إضافته إلى قاعدة البيانات
      _bookings.add(Booking(
        id: bookingId, // استخدام المعرّف الفريد
        userName: booking.userName,
        vehicleDetails: booking.vehicleDetails,
        startDate: booking.startDate,
        endDate: booking.endDate,
        status: booking.status,
        createdAt: booking.createdAt,
        ownerName: '',
      ));

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      throw error;
    }
  }


  // دالة لحذف حجز من قاعدة البيانات
  Future<void> deleteBooking(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(id).delete();
      _bookings.removeWhere((booking) => booking.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      throw error;
    }
  }

  // دالة لتحديث بيانات حجز في قاعدة البيانات
  Future<void> updateBooking(
      String id, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(id)
          .update(updatedData);
      final index = _bookings.indexWhere((booking) => booking.id == id);
      if (index != -1) {
        _bookings[index] = Booking.fromMap(updatedData, id);
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      throw error;
    }
  }
}
