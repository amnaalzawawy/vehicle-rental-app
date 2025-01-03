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
    required this.pricePerDay,
  });

  // تحويل من Map إلى CarModel
  factory CarModel.fromMap(Map<String, dynamic> map, String id) {
    return CarModel(
      id: id,
      name: map['name'] ?? '', // تأكد من وجود الحقل name
      category: map['category'] ?? '', // تأكد من وجود الحقل category
      ownerName: map['ownerName'] ?? '', // تأكد من وجود الحقل ownerName
      imageUrls: List<String>.from(map['imageUrls'] ?? []), // معالجة الصور
      isBooking: map['isBooking'] ?? false, // التحقق من الحقل isBooking
      pricePerDay: map['pricePerDay']?.toDouble() ?? 0.0, // معالجة pricePerDay
    );
  }

  // تحويل من CarModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name, // تأكد من إضافة الحقل name
      'category': category, // إضافة الحقل category
      'ownerName': ownerName, // إضافة الحقل ownerName
      'imageUrls': imageUrls, // إضافة الصور
      'isBooking': isBooking, // إضافة حالة الحجز
      'pricePerDay': pricePerDay, // المفتاح الصحيح لـ pricePerDay
    };
  }
}
