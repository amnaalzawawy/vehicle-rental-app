class CarModel {
  late final String id;
  final String name;
  final String category; // نوع الوقود
  final String ownerName;
  final List<String> imageUrls; // صور المركبة
  final double pricePerDay;
  final bool isBooking;

  CarModel({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerName,
    required this.imageUrls,
    required this.pricePerDay,
    required this.isBooking,
  });

  factory CarModel.fromMap(Map<String, dynamic> data, String id) {
    return CarModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      ownerName: data['ownerName'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      pricePerDay: (data['pricePerDay'] ?? 0).toDouble(),
      isBooking: data['isBooking'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      /*'name': name,
      'category': category,
      'ownerName': ownerName,
      'imageUrls': imageUrls,
      'pricePerDay': pricePerDay,
      'isBooking': isBooking,*/
      'name': name,
      'category': category,
      'ownerName': ownerName,
      'imageUrls': imageUrls,
      'isBooking': isBooking,
      'pricePerDay': pricePerDay
    };
  }
}
