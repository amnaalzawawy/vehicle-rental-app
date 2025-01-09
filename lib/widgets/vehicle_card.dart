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
        // Handle any errors here
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
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xfff78B00), width: 2), // إطار برتقالي
        borderRadius: BorderRadius.circular(12), // إضافة زاوية مدورة
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // عرض الصورة الأولى من الصور
          imageURL != null
              ? Image.network(
            imageURL!, // عرض أول صورة
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          )
              : Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // اسم المركبة
                Text(
                  car.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                // فئة المركبة
                Text(
                  'الفئة: ${car.category}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.right,),
                const SizedBox(height: 5),
                // السعر
                Text(
                  'السعر: ${car.pricePerDay.toStringAsFixed(2)} د.ل',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.right,),
                const SizedBox(height: 10),
                // زر الحجز
                ElevatedButton(
                  onPressed: widget.onPressed, // تمرير الحدث
                  style: ElevatedButton.styleFrom(
                   // backgroundColor: Color(0xfff78B00), // خلفية البرتقالي
                    //onPrimary: Colors.white, // نص أبيض
                    minimumSize: Size(double.minPositive, 20), // حجم الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // زاوية مدورة
                    ),
                    shadowColor: Colors.orangeAccent, // لون الظل
                    elevation: 8, // تأثير الظل
                  ),
                  child: const Text('احجز الآن', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
