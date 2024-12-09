import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserScreen extends StatelessWidget {
  final String userId;
  final dynamic userData;

  EditUserScreen({super.key, required this.userId, required this.userData});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = userData['name'];
    _phoneController.text = userData['phone'];

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات المستخدم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'الاسم'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  if (!RegExp(r'^(?:\+218|0)(91|92|93|94|95|96|97|98|99)[0-9]{6,7}$').hasMatch(value)) {
                    return 'رقم الهاتف غير صالح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection('users').doc(userId).update({
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}