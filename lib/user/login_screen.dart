import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller للحقلين (الاسم الأول والاسم الثاني)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // متغيرات للأخطاء
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;

  // متغير للتخزين المؤقت للرمز OTP
  String? _verificationId;

  // دالة لتسجيل الدخول باستخدام رقم الهاتف
  Future<void> _loginWithPhone() async {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length != 9) {
      setState(() {
        _phoneError = 'الرجاء إدخال رقم هاتف ليبي صحيح';
      });
      return;
    }

    // هنا نرسل OTP إلى الرقم المدخل
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+218$phone',  // رقم الهاتف مع كود ليبيا
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // في حال تم التحقق تلقائيًا
        await FirebaseAuth.instance.signInWithCredential(credential);
        _saveUserData();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _phoneError = 'فشل التحقق: ${e.message}';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        // عرض شاشة إدخال OTP
        Navigator.pushNamed(context, '/otpScreen');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // دالة لحفظ البيانات بعد التحقق
  Future<void> _saveUserData() async {
    // هنا سنحفظ البيانات في Firebase
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      setState(() {
        _firstNameError = firstName.isEmpty ? 'الرجاء إدخال الاسم الأول' : null;
        _lastNameError = lastName.isEmpty ? 'الرجاء إدخال الاسم الثاني' : null;
      });
      return;
    }

    // تخزين بيانات المستخدم في Firebase بعد التحقق
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // حفظ الاسم الأول واسم العائلة في قاعدة البيانات (Firestore)
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': user.phoneNumber,
      });
      // بعد حفظ البيانات يمكن توجيه المستخدم إلى الصفحة الرئيسية
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // حقل الاسم الأول
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'الاسم الأول',
                errorText: _firstNameError,
              ),
            ),
            SizedBox(height: 16.0),

            // حقل الاسم الثاني
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'الاسم الثاني',
                errorText: _lastNameError,
              ),
            ),
            SizedBox(height: 16.0),

            // حقل رقم الهاتف
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف الليبي',
                hintText: 'مثال: 912345678',
                errorText: _phoneError,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),

            // زر لتسجيل الدخول
            ElevatedButton(
              onPressed: _loginWithPhone,
              child: Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
