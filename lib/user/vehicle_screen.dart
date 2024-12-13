import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // لاستيراد Firebase Firestore
import 'package:untitled2/user/vehicle_detalis_screen.dart';
import '../models/car.dart';
import '../widgets/vehicle_card.dart';


class CarDisplayScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CarModel>> fetchCars() async {
    try {
      // الحصول على البيانات من Firebase باستخدام get()
      final querySnapshot = await _firestore.collection('cars').get();
      // تحويل البيانات إلى قائمة من CarModel
      return querySnapshot.docs.map((doc) {
        return CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      // في حال حدوث خطأ
      throw Exception('فشل في تحميل المركبات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض المركبات'),
      ),
      body: FutureBuilder<List<CarModel>>(
        future: fetchCars(),  // استدعاء الدالة التي تستخدم get()
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // تحميل البيانات
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ في تحميل البيانات')); // التعامل مع الخطأ
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد مركبات لعرضها'));
          }

          final cars = snapshot.data!;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              return CarCard(
                car: cars[index],
                onPressed: () {
                  // الانتقال إلى شاشة تفاصيل المركبة عند الضغط على الزر
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(car: cars[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
