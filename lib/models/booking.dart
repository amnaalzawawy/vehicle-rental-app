import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String? carId;
  final String? userId;
  final DateTime? date;
  final double? totalAmount;
  final String? id;
  final String? userName;
  final String? vehicleDetails;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final DateTime? createdAt;

  Booking({
    this.carId,
    this.userId,
    this.date,
    this.totalAmount,
    this.userName,
    this.vehicleDetails,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'userId': userId,
      'date': date?.toIso8601String(),
      'totalAmount': totalAmount,
      'userName': userName,
      'vehicleDetails': vehicleDetails,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'createdAt': createdAt,
    };
  }

factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      carId: data['carId'],
      userId: data['userId'],
      date: DateTime.parse(data['date']),
      totalAmount: data['totalAmount'],
      id: data["id"],
      userName: data['userName'] ?? '',
      vehicleDetails: data['vehicleDetails'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
