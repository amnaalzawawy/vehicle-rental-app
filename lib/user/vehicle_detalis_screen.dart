import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/user/booking_details_screen.dart';
import '../models/car.dart';
import '../providers/current_user_provider.dart';

class CarDetailScreen extends StatefulWidget {
  final CarModel car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<StatefulWidget> createState() => CarDetailScreenState();
}

class CarDetailScreenState extends State<CarDetailScreen> {
  List<String> imageURLs = [];
  UserModel? owner;

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
          crossAxisAlignment: CrossAxisAlignment.end,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageURLs[index],
                        fit: BoxFit.cover,
                      ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 30),
                  // اسم المركبة
                  _buildDetailText('اسم المركبة: ${widget.car.name}', isData: true, isBold: true),
                  const SizedBox(height: 10),
                  // الفئة
                  _buildDetailText('الفئة: ${widget.car.category}', isData: true, isBold: true),
                  const SizedBox(height: 10),
                  // اسم المالك
                  _buildDetailText('اسم المالك: ${owner?.firstName ?? "غير متوفر"}', isData: true , isBold: true),
                  const SizedBox(height: 10),
                  // المسافة
                  _buildDetailText('المسافة المقطوعة: ${widget.car.distanceMeter}', isData: true , isBold: true),
                  const SizedBox(height: 10),
                  // نوع الوقود
                  _buildDetailText('نوع الوقود: ${widget.car.fuelType}', isData: true, isBold: true),
                  const SizedBox(height: 10),
                  // رقم اللوحة
                  _buildDetailText('رقم اللوحة: ${widget.car.plateNumber}', isData: true , isBold: true),
                  const SizedBox(height: 10),
                  // عدد المقاعد
                  _buildDetailText('عدد المقاعد: ${widget.car.seatsNumber}', isData: true , isBold: true),
                  const SizedBox(height: 10),
                  // نوع النقل
                  _buildDetailText('نوع الناقل: ${widget.car.transmissionType}', isData: true , isBold: true),
                  const SizedBox(height: 10),
                  // السعر اليومي
                  _buildDetailText('السعر اليومي: ${widget.car.pricePerDay} د.ل', isData: true , isBold: true),
                  const SizedBox(height: 50),
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: Colors.orangeAccent,
                      ),
                      child: const Text(
                        'احجز الآن',
                        style: TextStyle(fontSize: 18),
                      ),
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

  // Widget لبناء النصوص مع تغيير اللون والخط حسب ما إذا كانت ثابتة أو متغيرة
  Widget _buildDetailText(String text, {required bool isData, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal, // النص الثابت بالخط العريض
          color: isData ? Colors.black : Colors.black87, // اللون الأسود القاتم للنص الثابت
        ),
      ),
    );
  }
}
