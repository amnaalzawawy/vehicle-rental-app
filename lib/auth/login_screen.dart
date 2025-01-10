import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _saveUserSession(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

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
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

        if (userDoc.exists) {
          String userId = userDoc['userId'];
          await _saveUserSession(userId);
          String role = userDoc['role'];
          _navigateToRoleScreen(role);
        } else {
          await _addNewUser(email, password, firstName, lastName, phone);
        }
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

  void _navigateToRoleScreen(String role) {
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/CarScreen');
    } else if (role == 'owner') {
      Navigator.pushReplacementNamed(context, '/ownerDashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/myAccount');
    }
  }

  Future<void> _addNewUser(String email, String password, String firstName,
      String lastName, String phone) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _saveUserSession(userId);
      Navigator.pushReplacementNamed(context, '/myAccount');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('حدث خطأ أثناء إضافة المستخدم. حاول مرة أخرى!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('التسجيل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon.jpg',
                    height: 100,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    icon: Icons.email,
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
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    icon: Icons.lock,
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
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'الاسم الأول',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'الاسم الأخير',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 100.0),
                      ),
                      child: const Text(
                        'التسجيل',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
