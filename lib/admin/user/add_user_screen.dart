

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}
class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role ;
  String? password;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مستخدم/مالك جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'الاسم الأول'),
                onSaved: (value) => firstName = value,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الاسم الأخير'),
                onSaved: (value) => lastName = value,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                onSaved: (value) => email = value,
                validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                onSaved: (value) => phoneNumber = value,
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
                onChanged: (value) => setState(() => role = value),
              ),
              // إظهار حقل كلمة المرور فقط إذا لم يكن الدور "أدمن"
              if (role == 'أدمن') ...[
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'كلمة المرور'),
                  onSaved: (value) => password = value,
                  validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    userProvider.addUser(
                      UserModel(
                        userId: '', // سيتم تعيينه تلقائيًا من Firestore
                        firstName: firstName!,
                        lastName: lastName!,
                        phoneNumber: phoneNumber!,
                        profileImageBase64: null,
                        role: role!,
                        email: email!,
                        passwordHash: '',
                        // passwordHash: password ?? '', // إذا كان دور "أدمن"، لن يكون هناك كلمة مرور
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('إضافة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
