import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car.dart';

class CarCard extends StatefulWidget {
  final CarModel car; // استلام نموذج المركبة
  final VoidCallback onPressed; // تمرير الحدث عند الضغط على زر الحجز

  CarCard({required this.car, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return CarCardState();
  }
}

class CarCardState extends State<CarCard> {
  String? imageURL = null;

  void getImageURL() async {
    if (widget.car.images.isNotEmpty) {
      try {
        var url = await Supabase.instance.client.storage
            .from("cars")
            .createSignedUrl(widget.car.images[0].replaceAll("cars/", ""), 60000);
        setState(() {
          imageURL = url;
        });
      } catch (e) {
        // handle error here if necessary
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    var car = widget.car;

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.orange, width: 2), // تغيير لون الإطار إلى البرتقالي
        borderRadius: BorderRadius.circular(10), // إضافة زاوية منحنية للإطار
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض الصورة الأولى من الصور
          imageURL != null
              ? Image.network(
            imageURL!, // عرض أول صورة
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          )
              : Container(height: 150, color: Colors.grey),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المركبة
                Text(
                  car.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // فئة المركبة
                Text(
                  'الفئة: ${car.category}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                // السعر
                Text(
                  'السعر: ${car.pricePerDay.toStringAsFixed(2)} د.ل',
                  // عرض السعر
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                const SizedBox(height: 10),
                // زر الحجز
                ElevatedButton(
                  onPressed: widget.onPressed, // تمرير الحدث
                  child: const Text('احجز الآن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
