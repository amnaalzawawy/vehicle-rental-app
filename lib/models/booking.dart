class Booking {
  final String carId;
  final String userId;
  final DateTime date;
  final double totalAmount;

  Booking({
    required this.carId,
    required this.userId,
    required this.date,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'userId': userId,
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }

  static Booking fromMap(Map<String, dynamic> map) {
    return Booking(
      carId: map['carId'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      totalAmount: map['totalAmount'],
    );
  }
}
