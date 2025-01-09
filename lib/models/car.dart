import 'dart:io';

class CarModel {
  String id;
  String name; // اسم المركبة
  String category;
  String owner;
  List<String> images = [];
  bool isBooking; // حالة الحجز (للعرض فقط)
  double pricePerDay;
  String distanceMeter;
  String fuelType;
  String plateNumber;
  String seatsNumber;
  String transmissionType;

  CarModel({
    required this.id,
    required this.name,
    required this.category,
    required this.owner,
    required  this.pricePerDay,
    this.images = const [],
    this.isBooking = false,
    required  this.distanceMeter,
  required  this.fuelType,
  required  this.plateNumber,
  required  this.seatsNumber,
  required  this.transmissionType,
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
      pricePerDay: (map['price'] as num?)?.toDouble() ?? 0.toDouble(),
      distanceMeter: map['distanceMeter'] ?? '',
      fuelType: map['fuelType'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      seatsNumber: map['seatsNumber'] ?? '',
      transmissionType: map['transmissionType'] ?? '',

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
      "owner": owner,
      "distanceMeter":distanceMeter,
      "fuelType":fuelType,
      "plateNumber":plateNumber,
      "seatsNumber":seatsNumber,
      "transmissionType":transmissionType,
    };
  }
}
