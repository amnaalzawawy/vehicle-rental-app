import 'package:flutter/material.dart';
import 'cars_screen.dart'; // استدعاء شاشة عرض المركبات

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (صورة من مجلد assets)
          SizedBox.expand(
            child: Image.asset(
              'assets/R.jpg', // مسار الصورة
              fit: BoxFit.cover, // جعل الصورة تغطي الشاشة بالكامل
            ),
          ),
          // المحتوى فوق الصورة
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'تشكيلة متنوعة من المركبات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // مسافة بين السطرين
                Text(
                  'تمتع بالتجربة',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // الزر في أسفل الشاشة
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VehicleListScreen()),
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  // التنقل إلى شاشة عرض المركبات
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VehicleListScreen()),
                  );
                },
                child: const Text('عرض المركبات'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
