import 'dart:io';

class CarModel {
  String id;
  String name; // اسم المركبة
  String category;
  String owner;
  List<String> images = [];
  bool isBooking; // حالة الحجز (للعرض فقط)
  double pricePerDay;
  CarModel({
    required this.id,
    required this.name,
    required this.category,
    required this.owner,
    required  this.pricePerDay,
    this.images = const [],
    this.isBooking = false,
  });

  // تحويل من Map إلى CarModel
  factory CarModel.fromMap(Map<String, dynamic> map, String id) {
    return CarModel(
      id: id,
      name: map['name'] ?? '', // تأكد من إضافة الحقل name
      category: map['category'] ?? '',
      owner: map['owner'] ?? '',
      images: List<String>.from(map['imageUrls'] ?? []),
      isBooking: map['isBooking'] ?? false,
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.toDouble(),
    );
  }

  // تحويل من CarModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name, // تأكد من إضافة الحقل name
      'category': category,
      'ownerName': owner,
      'imageUrls': images,
      'isBooking': isBooking,
      'price':  pricePerDay,
      "owner": owner
    };
  }
}
