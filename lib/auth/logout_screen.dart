import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/providers/current_user_provider.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).logout().then(
                      (value) {
                        // هنا الكود لمسح البيانات أو تسجيل الخروج
                        Navigator.pushReplacementNamed(
                            context, '/login'); // يوجه إلى شاشة تسجيل الدخول
                      },
                    );
                  },
                  child: Text('Yes'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // العودة إلى الشاشة السابقة
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
