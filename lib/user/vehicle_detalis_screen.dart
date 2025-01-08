import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import 'package:untitled2/user/booking_details_screen.dart';
import '../models/car.dart';

class CarDetailScreen extends StatefulWidget {
  final CarModel car;

  CarDetailScreen({required this.car});

  @override
  State<StatefulWidget> createState() => CarDetailScreenState();
}

class CarDetailScreenState extends State<CarDetailScreen> {
  List<String> imageURLs = [];
  UserModel? owner = null;

  void getImageURL() async {
    if (widget.car.images.isNotEmpty) {
      try {
        for (var img in widget.car.images) {
          var url = await Supabase.instance.client.storage
              .from("cars")
              .createSignedUrl(img.replaceAll("cars/", ""), 60000);
          setState(() {
            imageURLs.add(url);
          });
        }
      } catch (_e) {}
    }
  }


  void getUserDetails() async {
    final user = await UserProvider().getUser(widget.car.owner);
    print("Getting owner details");
    print(widget.car.owner);
    print(user);
    setState(() {
      owner = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عرض الصور المتعددة للمركبة في شريط أفقي متحرك
            imageURLs.isNotEmpty ? SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageURLs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imageURLs[index],
                    ),
                  );
                },
              ),
            ): Container(
              height: 200,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Text("لاتوجد صور لهذه المركبة"),
            ),
            // تفاصيل المركبة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفئة: ${widget.car.category}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اسم المالك: ${owner?.firstName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // عرض السعر اليومي من قاعدة البيانات
                  Text(
                    'السعر اليومي: ${widget.car.pricePerDay} د.ل',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // زر الحجز
                  Center(
                    child: ElevatedButton(
                    onPressed: () {
                      // الانتقال إلى شاشة الحجز
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookingScreen(car: widget.car)),
                      );
                    },
                    child: const Text('احجز الآن'),
                  ),
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
