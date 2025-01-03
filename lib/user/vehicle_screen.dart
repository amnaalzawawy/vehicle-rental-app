import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import 'package:untitled2/widgets/custom_user_drawer.dart';

import '../models/car.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/filter_vehicle.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_detalis_screen.dart';

class CarDisplayScreen extends StatefulWidget {
  const CarDisplayScreen({super.key});

  @override
  CarDisplayScreenState createState() => CarDisplayScreenState();
}

class CarDisplayScreenState extends State<CarDisplayScreen> {
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
    UserProvider().getCurrentUser().then((user) {
      var querySnapshot = _firestore.collection('cars');

      if (user?.role == "owner") {
        querySnapshot.where("owner", isEqualTo: user!.userId).get().then(
          (value) {
            setState(() {
              _cars = value.docs
                  .map((doc) => CarModel.fromMap(doc.data(), doc.id))
                  .toList();
              _filteredCars = List.from(
                  _cars); // تعيين كل المركبات إلى _filteredCars في البداية
            });
          },
        );
      } else {
        querySnapshot.get().then(
          (value) {
            setState(() {
              _cars = value.docs
                  .map((doc) => CarModel.fromMap(doc.data(), doc.id))
                  .toList();
              _filteredCars = List.from(
                  _cars); // تعيين كل المركبات إلى _filteredCars في البداية
            });
          },
        );
      }
    });
  }

  // تطبيق الفلاتر
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filteredCars = _cars.where((car) {
        bool matchesCategory =
            filters['category'] == null || car.category == filters['category'];
        bool matchesOwner =
            filters['owner'] == null || car.owner == filters['owner'];

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
    // if (role == 'admin') {
    //   Navigator.pushReplacementNamed(context, '/CarScreen');
    // } else if (role == 'owner') {
    //   Navigator.pushReplacementNamed(context, '/ownerDashboard');
    // } else {
    //   Navigator.pushReplacementNamed(context, '/myAccount');
    // }
    // يمكنك إضافة التنقل بين الصفحات هنا
    var userProvider = UserProvider();

    userProvider.getCurrentUser().then(
      (user) {
        if (user != null) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, "/myBooking");

              break;
            case 2:
              if (user.role == "owner") {
                Navigator.pushNamed(context, "/owner/manage");
              }
              if (user.role == "user") {
                Navigator.pushNamed(context, "/myAccount");
              }

              break;
          }
        } else {
          Navigator.pushNamed(context, "/login");
        }
      },
    );
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
                : CarCard(car: _cars[0], onPressed: () {
                  print("On card action");
                },)
            // ListView.builder(
            //         itemCount: _filteredCars.length,
            //         itemBuilder: (context, index) {
            //           return CarCard(
            //             car: _filteredCars[index],
            //             onPressed: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) =>
            //                       CarDetailScreen(car: _filteredCars[index]),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //       ),
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
