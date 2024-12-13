
/*
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:car_rental_admin/firebase_servise.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _walletController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  // دالة لإضافة مستخدم إلى Firestore
  void _addUser() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _walletController.text.isNotEmpty) {
      final newUser = UserModel(
        userId: DateTime.now().toString(), // يمكن تحسين التعيين باستخدام معرف فريد
        phoneNumber: _phoneController.text,
        walletBalance: double.parse(_walletController.text), name: '',
      );

      await _firebaseService.addUser(newUser); // إضافة المستخدم إلى Firestore

      // إعادة تعيين الحقول بعد إضافة المستخدم
      _nameController.clear();
      _phoneController.clear();
      _walletController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة المستخدم بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _walletController,
              decoration: InputDecoration(labelText: 'رصيد المحفظة'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}*/
