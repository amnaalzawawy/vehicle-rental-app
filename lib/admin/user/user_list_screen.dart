/*

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'package:car_rental_admin/firebase_servise.dart';
class UserListScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المستخدمين'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ'));
          }

          final users = snapshot.data!.docs
              .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.phoneNumber),
                subtitle: Text('رصيد المحفظة: ${user.walletBalance}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // يمكنك إضافة منطق لتحديث بيانات المستخدم
                    _showEditDialog(context, user);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    final _walletController = TextEditingController(text: user.walletBalance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تحديث بيانات المستخدم'),
          content: TextField(
            controller: _walletController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'رصيد المحفظة'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // تحديث رصيد المحفظة للمستخدم
                _firebaseService.updateUserWallet(user.userId, double.parse(_walletController.text));
                Navigator.of(context).pop();
              },
              child: const Text('تحديث'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}*/
