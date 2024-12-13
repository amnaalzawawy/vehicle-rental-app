import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String carId;
  final String carName;
  final String availability;
  final double dailyRate;
  final String fuelType;
  final String ownerId;
  final int seatingCapacity;
  final String vehicleClass;

  Vehicle({
    required this.carId,
    required this.carName,
    required this.availability,
    required this.dailyRate,
    required this.fuelType,
    required this.ownerId,
    required this.seatingCapacity,
    required this.vehicleClass,
  });

  // تحويل بيانات Firestore إلى كائن Vehicle
  factory Vehicle.fromMap(String id, Map<String, dynamic> data) {
    return Vehicle(
      carId: id,
      carName: data['carName'] ?? '',
      availability: data['availability'] ?? '',
      dailyRate: (data['dailyRate'] as num?)?.toDouble() ?? 0.0,
      fuelType: data['fuelType'] ?? '',
      ownerId: data['ownerId'] ?? '',
      seatingCapacity: data['seatingCapacity'] ?? 0,
      vehicleClass: data['vehicleClass'] ?? '',
    );
  }

  get imageUrl => null;

  // تحويل كائن Vehicle إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'carName': carName,
      'availability': availability,
      'dailyRate': dailyRate,
      'fuelType': fuelType,
      'ownerId': ownerId,
      'seatingCapacity': seatingCapacity,
      'vehicleClass': vehicleClass,
    };
  }

  // إنشاء مركبة جديدة في Firestore
  static Future<void> createVehicle(Vehicle vehicle) async {
    try {
      await FirebaseFirestore.instance.collection('vehicles').add(vehicle.toMap());
    } catch (e) {
      print('Error creating vehicle: $e');
      throw e;
    }
  }

  // تحديث مركبة موجودة في Firestore
  static Future<void> updateVehicle(String carId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('vehicles').doc(carId).update(updatedData);
    } catch (e) {
      print('Error updating vehicle: $e');
      throw e;
    }
  }

  // حذف مركبة من Firestore
  static Future<void> deleteVehicle(String carId) async {
    try {
      await FirebaseFirestore.instance.collection('vehicles').doc(carId).delete();
    } catch (e) {
      print('Error deleting vehicle: $e');
      throw e;
    }
  }

  // جلب مركبة واحدة باستخدام معرفها
  static Future<Vehicle?> getVehicleById(String carId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('vehicles').doc(carId).get();
      if (doc.exists) {
        return Vehicle.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching vehicle by ID: $e');
      throw e;
    }
  }

  // جلب قائمة المركبات مع خيار البحث
  static Future<List<Vehicle>> searchVehicles({String? query}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('vehicles').get();
      return querySnapshot.docs.map((doc) {
        final vehicle = Vehicle.fromMap(doc.id, doc.data());
        if (query == null || vehicle.carName.contains(query)) {
          return vehicle;
        }
        return null;
      }).whereType<Vehicle>().toList();
    } catch (e) {
      print('Error searching vehicles: $e');
      throw e;
    }
  }
}
