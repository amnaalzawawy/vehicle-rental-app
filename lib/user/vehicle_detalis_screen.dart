import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/user/booking_details_screen.dart';
import '../models/car.dart';


class CarDetailScreen extends StatelessWidget {
  final CarModel car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // عرض الصور المتعددة للمركبة في شريط أفقي متحرك
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: car.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(car.images[index]),
                  );
                },
              ),
            ),
            // تفاصيل المركبة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفئة: ${car.category}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'اسم المالك: ${car.owner}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  // عرض السعر اليومي من قاعدة البيانات
                  Text(
                    'السعر اليومي: ${car.pricePerDay} د.ل',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // زر الحجز
                  ElevatedButton(
                    onPressed: () {
                      // الانتقال إلى شاشة الحجز
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(car: car)
                        ),
                      );
                    },
                    child: Text('احجز الآن'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
