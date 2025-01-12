import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/user.dart';
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
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _fetchCars();
    var userProvider = UserProvider();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    });

    userProvider.getCurrentUser().then(
      (value) {
        setState(() {
          user = value;
        });
      },
    );
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

    // يمكنك إضافة التنقل بين الصفحات هنا
    var userProvider = UserProvider();

    userProvider.getCurrentUser().then(
      (user) {
        if (user != null) {
          switch (index) {
            case 1:
              if (user.role == "owner") {
                Navigator.pushNamed(context, "/owner/bookings");
              }
              if (user.role == "user") {
                Navigator.pushNamed(context, "/myBooking");
              }

              break;
            case 2:
              if (user.role == "owner") {
                Navigator.pushNamed(context, "/owner/account");
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
        title: const Text('عرض المركبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
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
      drawer: const CustomDrawer2(),
      body: Column(
        children: [
          Expanded(
            child: _filteredCars.isEmpty
                ? const Center(child: Text('لا توجد مركبات لعرضها'))
                : ListView.builder(
                    itemCount: _filteredCars.length,
                    itemBuilder: (context, index) {
                      return CarCard(
                        car: _filteredCars[index],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CarDetailScreen(car: _filteredCars[index]),
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
      floatingActionButton: user?.role == "owner"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/owner/manage");
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
