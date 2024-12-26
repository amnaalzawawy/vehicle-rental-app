import 'package:flutter/material.dart';
import 'dart:io';  // لإضافة دعم الملفات المحلية
import '../models/car.dart';

class CarCard extends StatelessWidget {
  final CarModel car;  // استلام نموذج المركبة
  final VoidCallback onPressed;  // تمرير الحدث عند الضغط على زر الحجز

  CarCard({required this.car, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض الصورة الأولى من الصور
          car.imageUrls.isNotEmpty
              ? car.imageUrls[0].startsWith('http')  // تحقق إذا كان الرابط هو رابط إنترنت
              ? Image.network(
            car.imageUrls[0], // عرض أول صورة من الإنترنت
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          )
              : Image.file(
            File(Uri.parse(car.imageUrls[0]).toFilePath()),  // معالجة المسار المحلي بشكل صحيح
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          )
              : Container(height: 150, color: Colors.grey), // عرض حاوية بديلة إذا كانت الصورة فارغة

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المركبة
                Text(
                  car.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // فئة المركبة
                Text(
                  'الفئة: ${car.category}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                // السعر
                Text(
                  'السعر: ${car.pricePerDay.toStringAsFixed(2)} ', // عرض السعر
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                SizedBox(height: 10),
                // زر الحجز
                ElevatedButton(
                  onPressed: onPressed,  // تمرير الحدث
                  child: Text('احجز الآن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
