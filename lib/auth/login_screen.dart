import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = true; // لتحديد هل هي تسجيل دخول أو تسجيل حساب جديد
  String _selectedRole = 'ادمن'; // القيمة الافتراضية

  Future<void> _submit() async {
    final auth = FirebaseAuth.instance;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // تسجيل الدخول
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // التحقق من البريد الإلكتروني
        if (auth.currentUser != null && !auth.currentUser!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email.')),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/users');
        }
      } else {
        // تسجيل حساب جديد
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // إرسال رمز التحقق عبر البريد الإلكتروني
        await auth.currentUser!.sendEmailVerification();

        // إضافة الدور في قاعدة البيانات
        await FirebaseFirestore.instance.collection('Admins').doc(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created! Please verify your email.')),
        );

        // توجيه المستخدم إلى واجهة لوحة الأدمن إذا كان دوره "ادمن"
        if (_selectedRole == 'ادمن') {
          Navigator.pushReplacementNamed(context, '/users');
        }

        // عرض نافذة إدخال الرمز للتحقق منه
        _showVerificationDialog();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') message = 'No user found for that email.';
      if (e.code == 'wrong-password') message = 'Incorrect password.';
      if (e.code == 'email-already-in-use') message = 'Email is already in use.';
      if (e.code == 'invalid-email') message = 'Invalid email address.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verify Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter the verification code sent to your email.'),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(labelText: 'Verification Code'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String verificationCode = _verificationCodeController.text.trim();
                if (verificationCode.isNotEmpty) {
                  // منطق التحقق من الرمز (يمكنك إضافة التحقق هنا)
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification successful!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the verification code.')),
                  );
                }
              },
              child: Text('Verify'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // منطق لإعادة إرسال رمز التحقق
                final auth = FirebaseAuth.instance;
                await auth.currentUser!.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Verification code resent.')),
                );
              },
              child: Text('Resend Code'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
              ),
              if (!_isLogin)
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: ['ادمن', 'مالك', 'مستخدم نهائي'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a role.';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                ),
              SizedBox(height: 10),
              // عرض زر التنقل بين صفحة تسجيل الدخول والتسجيل
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
