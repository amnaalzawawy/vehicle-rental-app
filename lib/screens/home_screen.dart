import 'package:flutter/material.dart';

import 'cars_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'), // صورة الشعار
            SizedBox(height: 20),
            Text('Welcome to the Rental App', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarsScreen()),
                );
              },
              child: Text('Browse Cars'),
            ),
          ],
        ),
      ),
    );
  }
}
