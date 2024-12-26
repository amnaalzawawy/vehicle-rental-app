import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/widgets/custom_user_drawer.dart';

import '../models/car.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/filter_vehicle.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_detalis_screen.dart';

class CarDisplayScreen extends StatefulWidget {
  @override
  _CarDisplayScreenState createState() => _CarDisplayScreenState();
}

class _CarDisplayScreenState extends State<CarDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CarModel> _cars = [];
  List<CarModel> _filteredCars = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  // جلب المركبات من قاعدة البيانات
  Future<void> _fetchCars() async {
    try {
      final querySnapshot = await _firestore.collection('cars').get();
      setState(() {
        _cars = querySnapshot.docs
            .map((doc) => CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        _filteredCars = List.from(_cars); // تعيين كل المركبات إلى _filteredCars في البداية
      });
    } catch (e) {
      print('فشل في جلب المركبات: $e');
    }
  }

  // تطبيق الفلاتر
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filteredCars = _cars.where((car) {
        bool matchesCategory = filters['category'] == null ||
            car.category == filters['category'];
        bool matchesOwner = filters['owner'] == null || car.ownerName == filters['owner'];

        // معالجة السعر
        bool matchesPrice = true;
        if (filters['priceRange'] != null) {
          String priceRange = filters['priceRange'];
          double price = car.pricePerDay; // السعر اليومي للمركبة

          if (priceRange == '<100') {
            matchesPrice = price < 100;
          } else if (priceRange == '<200') {
            matchesPrice = price < 200;
          } else if (priceRange == '<500') {
            matchesPrice = price < 500;
          }
        }

        return matchesCategory && matchesOwner && matchesPrice;
      }).toList();
    });
  }


  // دالة لتغيير الصفحة عند الضغط على عناصر الشريط
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // يمكنك إضافة التنقل بين الصفحات هنا
    switch (index) {
      case 0:
        print('فتح واجهة حسابي');
        break;
      case 1:
        print('فتح واجهة المحفظة');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض المركبات'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // عند الضغط على الأيقونة، يظهر الفلاتر
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: FilterWidget(onFilterApply: _applyFilters),
                  );
                },
              );
            },
          ),
        ],
      ),

      drawer: CustomDrawer2(),
      body: Column(
        children: [
          Expanded(
            child: _filteredCars.isEmpty
                ? Center(child: Text('لا توجد مركبات لعرضها'))
                : ListView.builder(
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                return CarCard(
                  car: _filteredCars[index],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(car: _filteredCars[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
