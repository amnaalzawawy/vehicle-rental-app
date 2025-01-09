import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/current_user_provider.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  final UserModel userData;

  EditUserScreen({super.key, required this.userId, required this.userData});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();

  String _role = "user";

  @override
  void initState() {
    super.initState();
    setState(() {
    _firstNameController.text = widget.userData.firstName;
    _lastNameController.text = widget.userData.lastName;
    _phoneController.text = widget.userData.phoneNumber;
    _emailController.text = widget.userData.email;
      _role = widget.userData.role;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل بيانات المستخدم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextFormField(
                enabled: false,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الالكتروني'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              Container(height: 12,),
              const Text("النوع"),
              DropdownButton<String>(
                items: <String>['admin', 'owner', 'user'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _role,
                onChanged: (value) {
                  setState(() {
                    _role = value ?? "user";
                  });
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate())  {
                    var newUser = widget.userData.copyWith(firstName: _firstNameController.text, lastName: _lastNameController.text, phoneNumber: _phoneController.text, role: _role);
                    print(newUser.firstName);
                    print(newUser.lastName);
                    print(newUser.phoneNumber);
                    print(newUser.userId);
                    await Provider.of<UserProvider>(context, listen: false).updateUser(newUser);
                    Navigator.pop(context);
                  }
                },
                child: const Text('تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}