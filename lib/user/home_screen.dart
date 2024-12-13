import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الشاشة الرئيسية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('مرحبًا بك في التطبيق!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vehicles');
              },
              child: Text('عرض المركبات'),
            ),
            ElevatedButton(
              onPressed: () {
                // عملية تسجيل الخروج
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
