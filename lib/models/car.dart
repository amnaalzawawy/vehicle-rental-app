class CarModel {
  String id;
  String name; // اسم المركبة
  String category;
  String ownerName;
  List<String> imageUrls;
  bool isBooking; // حالة الحجز (للعرض فقط)
  double pricePerDay;
  CarModel({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerName,
    required this.imageUrls,
    this.isBooking = false,
    required  this.pricePerDay,
  });

  // تحويل من Map إلى CarModel
  factory CarModel.fromMap(Map<String, dynamic> map, String id) {
    return CarModel(
      id: id,
      name: map['name'] ?? '', // تأكد من إضافة الحقل name
      category: map['category'] ?? '',
      ownerName: map['ownerName'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      isBooking: map['isBooking'] ?? false,
      pricePerDay: map['pricePerDay'] ?? 0.0,
    );
  }

  // تحويل من CarModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name, // تأكد من إضافة الحقل name
      'category': category,
      'ownerName': ownerName,
      'imageUrls': imageUrls,
      'isBooking': isBooking,
      'price':  pricePerDay,
    };
  }
}
