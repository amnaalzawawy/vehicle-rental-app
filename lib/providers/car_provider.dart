/*import 'package:flutter/material.dart';
import '../models/car.dart'; // استيراد نموذج Car

class CarProvider with ChangeNotifier {
  List<Car> _allCars = [];

  // قائمة السيارات
  List<Car> get allCars {
    return [..._allCars];
  }

  // دالة لتحميل السيارات (وضع بيانات افتراضية أو جلبها من Firebase)
  Future<void> fetchCars() async {
    // يمكنك جلب البيانات من قاعدة بيانات أو من أي مصدر آخر
    // على سبيل المثال، استخدام بيانات ثابتة للتوضيح

    _allCars = [
      Car(
        id: '1',
        name: 'تويوتا K7',
        model: '2020',
        imageUrl: 'assets/images/car1.jpg',
        price: 80.0,
        type: 'SUV',
        hasDiscount: true,
      ),
      Car(
        id: '2',
        name: 'هوندا CR-V',
        model: '2021',
        imageUrl: 'assets/images/car2.jpg',
        price: 70.0,
        type: 'SUV',
        hasDiscount: false,
      ),
    ];
    notifyListeners(); // تحديث الواجهة
  }

  // دالة لتصفية السيارات حسب السعر أو النوع أو الموديل
  List<Car> filterCars(String filterType) {
    if (filterType == 'price') {
      return _allCars.where((car) => car.price < 80.0).toList(); // تصفية السيارات ذات السعر الأقل من 80
    } else if (filterType == 'model') {
      return _allCars.where((car) => car.model == '2020').toList(); // تصفية الموديلات 2020
    } else if (filterType == 'type') {
      return _allCars.where((car) => car.type == 'SUV').toList(); // تصفية السيارات من نوع SUV
    } else {
      return _allCars; // إذا لم يكن هناك فلتر محدد، يتم عرض كل السيارات
    }
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  List<Vehicle> get vehicles => [..._vehicles];
  bool get isLoading => _isLoading;

  // جلب البيانات من Firebase
  Future<void> fetchVehicles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .get();

      _vehicles = snapshot.docs.map((doc) {
        return Vehicle.fromMap(doc.id, doc.data());
      }).toList();
    } catch (error) {
      print('Error fetching vehicles: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  // فلترة المركبات
  List<Vehicle> filterVehicles({double? maxPrice, String? vehicleClass, String? fuelType}) {
    return _vehicles.where((vehicle) {
      final matchesPrice = maxPrice == null || vehicle.dailyRate <= maxPrice;
      final matchesClass = vehicleClass == null || vehicle.vehicleClass == vehicleClass;
      final matchesFuel = fuelType == null || vehicle.fuelType == fuelType;

      return matchesPrice && matchesClass && matchesFuel;
    }).toList();
  }
}
