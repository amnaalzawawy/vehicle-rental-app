/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/car_provider.dart';
import '../widgets/vehicle_card.dart';

import 'car_details_screen.dart'; // شاشة تفاصيل المركبة

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  double? selectedPrice;
  String? selectedCategory;
  String? selectedFuelType;

  @override
  void initState() {
    super.initState();
    // جلب البيانات من القاعدة عند بدء الشاشة
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicles = vehicleProvider.filterVehicles(
      maxPrice: selectedPrice,
      vehicleClass: selectedCategory,
      fuelType: selectedFuelType,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض المركبات'),
      ),
      body: vehicleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // قسم الفلاتر
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // فلترة حسب السعر
                DropdownButton<double>(
                  hint: const Text('فلترة بالسعر'),
                  value: selectedPrice,
                  items: [50, 100, 150, 200].map((price) {
                    return DropdownMenuItem(
                      value: price.toDouble(),
                      child: Text('\$${price.toString()}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPrice = value;
                    });
                  },
                ),
                // فلترة حسب الفئة
                DropdownButton<String>(
                  hint: const Text('فئة المركبة'),
                  value: selectedCategory,
                  items: ['اقتصادية', 'عائلية', 'رياضية'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                // فلترة حسب نوع الوقود
                DropdownButton<String>(
                  hint: const Text('نوع الوقود'),
                  value: selectedFuelType,
                  items: ['بنزين', 'ديزل', 'كهرباء'].map((fuel) {
                    return DropdownMenuItem(
                      value: fuel,
                      child: Text(fuel),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFuelType = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // عرض المركبات
          Expanded(
            child: vehicles.isEmpty
                ? const Center(
              child: Text(
                'لا توجد مركبات',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (ctx, index) {
                final vehicle = vehicles[index];
                return VehicleCard(
                  imageUrl: vehicle.imageUrl,
                  name: vehicle.carName,
                  pricePerDay: vehicle.dailyRate,
                  isAvailable: vehicle.availability == 'available',
                  carId: vehicle.carId, // تمرير carId
                  onTap: () {
                    // الانتقال إلى صفحة التفاصيل
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(vehicleId: vehicle.carId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/car.dart'; // استدعاء الكلاس Vehicle من models
import '../widgets/vehicle_card.dart';
import 'car_details_screen.dart'; // شاشة تفاصيل المركبة

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;
  double? selectedPrice;
  String? selectedCategory;
  String? selectedFuelType;

  @override
  void initState() {
    super.initState();
    _fetchVehicles(); // استدعاء جلب المركبات عند بدء الشاشة
  }

  // دالة جلب المركبات من Firebase
  Future<void> _fetchVehicles() async {
    try {
      final fetchedVehicles = await Vehicle.searchVehicles(); // جلب المركبات باستخدام الكلاس
      setState(() {
        vehicles = fetchedVehicles;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching vehicles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // دالة تطبيق الفلاتر على القائمة
  List<Vehicle> _filterVehicles() {
    return vehicles.where((vehicle) {
      final matchesPrice = selectedPrice == null || vehicle.dailyRate <= selectedPrice!;
      final matchesClass = selectedCategory == null || vehicle.vehicleClass == selectedCategory;
      final matchesFuel = selectedFuelType == null || vehicle.fuelType == selectedFuelType;

      return matchesPrice && matchesClass && matchesFuel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = _filterVehicles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض المركبات'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // قسم الفلاتر
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // فلترة حسب السعر
                DropdownButton<double>(
                  hint: const Text('فلترة بالسعر'),
                  value: selectedPrice,
                  items: [50, 100, 150, 200].map((price) {
                    return DropdownMenuItem(
                      value: price.toDouble(),
                      child: Text('\$${price.toString()}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPrice = value;
                    });
                  },
                ),
                // فلترة حسب الفئة
                DropdownButton<String>(
                  hint: const Text('فئة المركبة'),
                  value: selectedCategory,
                  items: ['اقتصادية', 'عائلية', 'رياضية'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                // فلترة حسب نوع الوقود
                DropdownButton<String>(
                  hint: const Text('نوع الوقود'),
                  value: selectedFuelType,
                  items: ['بنزين', 'ديزل', 'كهرباء'].map((fuel) {
                    return DropdownMenuItem(
                      value: fuel,
                      child: Text(fuel),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFuelType = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // عرض المركبات
          Expanded(
            child: filteredVehicles.isEmpty
                ? const Center(
              child: Text(
                'لا توجد مركبات',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (ctx, index) {
                final vehicle = filteredVehicles[index];
                return VehicleCard(
                  imageUrl: vehicle.imageUrl,
                  name: vehicle.carName,
                  pricePerDay: vehicle.dailyRate,
                  isAvailable: vehicle.availability == 'available',
                  carId: vehicle.carId, // تمرير carId
                  onTap: () {
                    // الانتقال إلى صفحة التفاصيل
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(vehicleId: vehicle.carId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

