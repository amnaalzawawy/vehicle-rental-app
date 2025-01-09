import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/current_user_provider.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;
class EditUserScreen extends StatefulWidget {
  final String userId;
  final UserModel userData;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String email;
  late String phoneNumber;
  late String role;

  @override
  void initState() {
    super.initState();
    firstName = widget.user.firstName;
    lastName = widget.user.lastName;
    email = widget.user.email;
    phoneNumber = widget.user.phoneNumber;
    role = widget.user.role;
  }

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات المستخدم/المالك'),
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
                initialValue: firstName,
                decoration: InputDecoration(labelText: 'الاسم الأول'),
                onSaved: (value) => firstName = value!,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: InputDecoration(labelText: 'الاسم الأخير'),
                onSaved: (value) => lastName = value!,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
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
                initialValue: email,
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                onSaved: (value) => email = value!,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                onSaved: (value) => phoneNumber = value!,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              DropdownButtonFormField<String>(
                value: role,
                decoration: InputDecoration(labelText: 'الدور'),
                items: [
                  DropdownMenuItem(value: 'مستخدم', child: Text('مستخدم')),
                  DropdownMenuItem(value: 'مالك', child: Text('مالك')),
                  DropdownMenuItem(value: 'أدمن', child: Text('أدمن')),
                ],
                onChanged: (value) => setState(() => role = value!),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    userProvider.updateUser(
                      UserModel(
                        userId: widget.user.userId,  // لا حاجة لتمرير userId مرة أخرى إذا كانت موجودة في UserModel
                        firstName: firstName,
                        lastName: lastName,
                        phoneNumber: phoneNumber,
                        profileImageBase64: widget.user.profileImageBase64,
                        role: role,
                        email: email,
                        passwordHash: '', // يمكن تعديل البريد الإلكتروني الآن
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('تحديث'),
                child: Text('حفظ التعديلات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
