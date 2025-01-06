import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات المستخدم/المالك'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text('حفظ التعديلات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
