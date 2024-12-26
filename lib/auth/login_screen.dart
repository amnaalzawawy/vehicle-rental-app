import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // دالة لتخزين الجلسة باستخدام SharedPreferences
  Future<void> _saveUserSession(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // دالة لتسجيل المستخدم
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final phone = _phoneController.text;

      try {
        // فحص إذا كان البريد الإلكتروني موجود في قاعدة البيانات
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

        if (userDoc.exists) {
          // إذا كان البريد موجودًا، تحقق من الدور واحفظ الجلسة
          String userId = userDoc['userId'];
          await _saveUserSession(userId);
          String role = userDoc['role'];
          _navigateToRoleScreen(role);
        } else {
          // إذا لم يكن البريد موجودًا، قم بإضافة المستخدم الجديد
          await _addNewUser(email, password, firstName, lastName, phone);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('حدث خطأ أثناء التسجيل. حاول مرة أخرى!'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // دالة لتوجيه المستخدم بناءً على الدور
  void _navigateToRoleScreen(String role) {
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/CarScreen');
    } else if (role == 'owner') {
      Navigator.pushReplacementNamed(context, '/ownerDashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/myAccount');
    }
  }

  // دالة لإضافة مستخدم جديد وحفظ بياناته في قاعدة البيانات
  Future<void> _addNewUser(String email, String password, String firstName,
      String lastName, String phone) async {
    try {
      // إنشاء حساب مستخدم جديد باستخدام Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // حفظ بيانات المستخدم في Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'role': 'user', // تعيين الدور كمستخدم عادي
        'createdAt': FieldValue.serverTimestamp(),
      });

      // حفظ الجلسة
      await _saveUserSession(userId);

      // التوجيه إلى واجهة المستخدم العادي
      Navigator.pushReplacementNamed(context, '/myAccount');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('حدث خطأ أثناء إضافة المستخدم. حاول مرة أخرى!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التسجيل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+@gmail\.com$').hasMatch(value)) {
                    return 'يرجى إدخال بريد إلكتروني صالح';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'الاسم الأول'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الأول';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'الاسم الأخير'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الأخير';
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
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('التسجيل'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
