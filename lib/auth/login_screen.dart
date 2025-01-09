import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // دالة لإضافة مستخدم جديد وحفظ بياناته في قاعدة البيانات
  Future<void> _addNewUser(String email, String password, String firstName,
      String lastName, String phone) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'role': 'user', // تعيين الدور كمستخدم عادي
        'createdAt': FieldValue.serverTimestamp(),
      });

      // التوجيه إلى واجهة المستخدم العادي
      Navigator.pushReplacementNamed(context, '/myAccount');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('حدث خطأ أثناء إضافة المستخدم. حاول مرة أخرى!'),
      ));
    }
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
        await _addNewUser(email, password, firstName, lastName, phone);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التسجيل'),
      ),
      body: currentUser == null
          ? _buildSignUpForm()
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final role = snapshot.data!['role'];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateToRoleScreen(role);
            });
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(
              child: Text('لا يمكن العثور على بيانات المستخدم.'));
        },
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
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
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
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
              decoration: const InputDecoration(labelText: 'الاسم الأول'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم الأول';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'الاسم الأخير'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم الأخير';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال رقم الهاتف';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('التسجيل'),
              ),
          ],
        ),
      ),
    );
  }
}
