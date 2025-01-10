import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String? carId;
  final String? userId;
  final DateTime? date;
  final double? totalAmount;
  final String? id;
  final String? userName;
  final Map<String, dynamic>? vehicleDetails; // تحديث نوع vehicleDetails إلى Map
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final DateTime? createdAt;
  final String ownerName;  // إضافة اسم المالك هنا


  Booking({
    this.carId,
    this.userId,
    this.date,
    this.totalAmount,
    this.id,
    this.userName,
    this.vehicleDetails,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    required this.ownerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'userId': userId,
      'date': date?.toIso8601String(),
      'totalAmount': totalAmount,
      'userName': userName,
      'vehicleDetails': vehicleDetails, // إضافة vehicleDetails
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'ownerName': ownerName,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> data, String id) {
    return Booking(
      id: id, // تعيين id هنا
      carId: data['carId'],
      userId: data['userId'],
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
      totalAmount: data['totalAmount'] != null ? data['totalAmount'].toDouble() : null,
      userName: data['userName'] ?? '',
      vehicleDetails: data['vehicleDetails'] != null ? Map<String, dynamic>.from(data['vehicleDetails']) : null, // تحويل vehicleDetails إلى Map
      startDate: data['startDate'] != null ? (data['startDate'] as Timestamp).toDate() : null,
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      status: data['status'] ?? 'Pending',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      ownerName: data ['ownerName'] ?? '',);
  }
}
