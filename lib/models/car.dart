
import 'dart:io';

class CarModel {
  String id;
  String name; // اسم المركبة
  String category;
  String ownerName;
  List<File>? image;
  bool isBooking; // حالة الحجز (للعرض فقط)
  double pricePerDay;

  CarModel({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerName,
    this.isBooking = false,
    required this.pricePerDay,
    this.image ,
  });

  // تحويل من Map إلى CarModel
  factory CarModel.fromMap(Map<String, dynamic> map, String id) {
    return CarModel(
      id: id,
      name: map['name'] ?? '', // تأكد من إضافة الحقل name
      category: map['category'] ?? '',
      ownerName: map['ownerName'] ?? '',
      // image: List<File>.from(map['imageUrls'] ?? []),
      isBooking: map['isBooking'] ?? false,
      pricePerDay: (map['pricePerDay'] ?? 0.0).toDouble(), // تحويل إلى double
    );
  }

  // تحويل من CarModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'ownerName': ownerName,
      'imageUrls': image,
      'isBooking': isBooking,
      'pricePerDay': pricePerDay,
    };
  }
}