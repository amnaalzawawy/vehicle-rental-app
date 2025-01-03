import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/car.dart';
import 'dart:io';  // لإضافة دعم الملفات المحلية

class CarProvider with ChangeNotifier {
  final CollectionReference _carCollection = FirebaseFirestore.instance.collection('cars');

  List<CarModel> _cars = [];
  List<CarModel> get cars => _cars;

  // وظيفة لإضافة مركبة جديدة
  Future<void> addCar(CarModel car) async {
    print("Adding new car");
    try {
      var user = UserProvider().firebaseUser;
      car.owner = user?.uid ?? "";
      var doc = await _carCollection.add(car.toMap());
      // supabase upload file
      var image = File((car.images ?? []).first);
      var extension = image.path.split(".").last;
      var filename = "${const Uuid().v4()}.$extension";
      final String fullPath = await Supabase.instance.client.storage.from('cars').upload(
        filename,
        image,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      _carCollection.doc(doc.id).update({
            "imageUrls":[fullPath]
          });

      await fetchCars(); // إعادة تحميل البيانات بعد الإضافة
      notifyListeners();
    } catch (e) {
      print("Error adding car: $e");
    }
  }

  // وظيفة لجلب قائمة المركبات
  Future<void> fetchCars() async {
    try {
      QuerySnapshot snapshot = await _carCollection.get();
      _cars = snapshot.docs.map((doc) => CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching cars: $e");
    }
  }

  // وظيفة لإحضار تفاصيل مركبة مفصلة باستخدام معرفها
  Future<CarModel?> getCarById(String id) async {
    try {
      DocumentSnapshot doc = await _carCollection.doc(id).get();
      if (doc.exists) {
        return CarModel.fromMap(doc.data() as Map<String, dynamic>, id);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching car by ID: $e");
      return null;
    }
  }

  // وظيفة لتعديل بيانات مركبة
  Future<void> updateCar(String id, CarModel updatedCar) async {
    try {
      await _carCollection.doc(id).update(updatedCar.toMap());
      await fetchCars(); // إعادة تحميل البيانات بعد التحديث
      notifyListeners();
    } catch (e) {
      print("Error updating car: $e");
    }
  }

  // وظيفة لحذف مركبة
  Future<void> deleteCar(String id) async {
    try {
      await _carCollection.doc(id).delete();
      _cars.removeWhere((car) => car.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting car: $e");
    }
  }

  // وظيفة للبحث ضمن المركبات حسب فئة أو اسم المالك
  List<CarModel> searchCars(String query) {
    return _cars.where((car) =>
    car.category.toLowerCase().contains(query.toLowerCase()) ||
        car.owner.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}