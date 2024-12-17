import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';

class CarProvider with ChangeNotifier {
  final CollectionReference _carCollection = FirebaseFirestore.instance.collection('cars');

  List<CarModel> _cars = [];
  List<CarModel> get cars => _cars;

  // وظيفة لجلب قائمة المركبات
  Future<void> fetchCars() async {
    try {
      /*QuerySnapshot snapshot = await _carCollection.get();
      _cars = snapshot.docs.map((doc) => CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      notifyListeners();  // التأكد من تحديث المستمعين بعد جلب البيانات
    } catch (e) {
      print("Error fetching cars: $e");
    }*/
      QuerySnapshot snapshot = await _carCollection.get();
      _cars = snapshot.docs.map((doc) {
        return CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching cars: $e");
    }
  }

  // إضافة مركبة جديدة
  Future<void> addCar(CarModel car) async {
    try {
      final docRef = await _carCollection.add(car.toMap());
      car.id = docRef.id;  // إضافة id بعد الإدخال
      _cars.add(car);  // إضافة السيارة للقائمة المحلية
      notifyListeners();  // التحديث بعد الإضافة
    } catch (e) {
      print("Error adding car: $e");
    }
  }

  // حذف مركبة
  Future<void> deleteCar(String id) async {
    try {
      await _carCollection.doc(id).delete();
      _cars.removeWhere((car) => car.id == id);  // إزالة السيارة من القائمة
      notifyListeners();  // التحديث بعد الحذف
    } catch (e) {
      print("Error deleting car: $e");
    }
  }

  // تحديث بيانات مركبة
  Future<void> updateCar(String id, CarModel updatedCar) async {
    try {
      await _carCollection.doc(id).update(updatedCar.toMap());
      // لا حاجة لجلب السيارات مرة أخرى بعد التحديث
      final index = _cars.indexWhere((car) => car.id == id);
      if (index != -1) {
        _cars[index] = updatedCar;
      }
      notifyListeners();  // التحديث بعد التعديل
    } catch (e) {
      print("Error updating car: $e");
    }
  }
  List<CarModel> searchCars(String query) {
    return _cars.where((car) => car.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
