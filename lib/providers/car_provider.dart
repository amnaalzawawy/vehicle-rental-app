import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';



class CarProvider with ChangeNotifier {
  final CollectionReference _carCollection = FirebaseFirestore.instance.collection('cars');

  List<CarModel> _cars = [];
  List<CarModel> get cars => _cars;

  // وظيفة لإضافة مركبة جديدة
  Future<void> addCar(CarModel car) async {
    try {
      await _carCollection.add(car.toMap());
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
        car.ownerName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
