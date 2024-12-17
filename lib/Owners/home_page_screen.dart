import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../provider/car_provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
import '../models/icons.dart';
import 'vehicle _Management_screen.dart'; // استدعاء الأيقونات
//import 'manage_car_page.dart'; // صفحة إدارة المركبات

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context, listen: false);

    // جلب البيانات بعد بناء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carProvider.fetchCars();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الرئيسية"),
        actions: [
          IconButton(
            icon: Icon(AppIcons.account), // أيقونة حسابي
            onPressed: () {
              // إضافة وظيفة التنقل إلى صفحة حسابي
              print("الذهاب إلى صفحة حسابي");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // زر إضافة مركبة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ManageCarPage()),
                );
              },
              icon: Icon(Icons.add),
              label: Text("إضافة مركبة"),
            ),
          ),
          // قائمة المركبات
          Expanded(
            child: Consumer<CarProvider>(
              builder: (context, provider, child) {
                if (provider.cars.isEmpty) {
                  return Center(child: Text("لا توجد مركبات حالياً"));
                }
                return ListView.builder(
                  itemCount: provider.cars.length,
                  itemBuilder: (context, index) {
                    final car = provider.cars[index];
                    return CarCard(
                      car: car,
                      onEdit: () {
                        // التنقل لصفحة الإدارة مع تمرير المركبة للتعديل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  ManageCarPage(car: car),
                          ),
                        );
                      },
                      onDelete: () {
                        provider.deleteCar(car.id);
                      },
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
