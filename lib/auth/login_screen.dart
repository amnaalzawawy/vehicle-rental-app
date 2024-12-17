/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _verificationId = '';
  bool _isLoading = false;

  // التحقق من دور المستخدم وتسجيل الدخول
  void _checkUserRole() async {
    setState(() => _isLoading = true);
    final phoneNumber = _phoneController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    try {
      // التحقق إذا كان المستخدم موجودًا في Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData['role'] == 'admin') {
          // إذا كان المستخدم أدمن، الانتقال إلى واجهة الأدمن
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else {
          // إذا كان مستخدمًا عاديًا، إرسال رمز التحقق
          _sendOtp(phoneNumber);
        }
      } else {
        // إذا لم يكن المستخدم موجودًا، إرسال رمز التحقق
        _sendOtp(phoneNumber);
      }
    } catch (e) {
      // التعامل مع الأخطاء
      print("خطأ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التحقق من المستخدم.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // إرسال رمز التحقق OTP
  void _sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+218$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // التحقق التلقائي وتسجيل الدخول
          await _auth.signInWithCredential(credential);
          _saveUserData();
          Navigator.pushReplacementNamed(context, '/user_dashboard');
        },
        verificationFailed: (FirebaseAuthException e) {
          // التعامل مع أخطاء التحقق
          print('فشل التحقق: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل التحقق: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // حفظ معرف التحقق وإظهار شاشة OTP
          setState(() => _verificationId = verificationId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                onVerified: _saveUserData,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // انتهاء صلاحية الرمز
          setState(() => _verificationId = verificationId);
        },
      );
    } catch (e) {
      // التعامل مع أخطاء الإرسال
      print('خطأ في إرسال OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إرسال رمز التحقق.')),
      );
    }
  }

  // حفظ بيانات المستخدم الجديد في Firestore
  void _saveUserData() async {
    final phoneNumber = _phoneController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    try {
      await _firestore.collection('users').doc(phoneNumber).set({
        'userId': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'walletBalance': 0.0,
        'role': 'user',
      });
    } catch (e) {
      print("خطأ في حفظ البيانات: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في حفظ بيانات المستخدم.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أهلًا بك!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'الاسم الأول'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'الاسم الأخير'),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'رقم الهاتف الليبي'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _checkUserRole,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _verificationId = '';
  bool _isLoading = false;

  // التحقق من صحة رقم الهاتف الليبي
  bool _isValidLibyanPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^(91|92|94)\d{7}$');
    return regex.hasMatch(phoneNumber);
  }

  // التحقق من دور المستخدم وتسجيل الدخول
  void _checkUserRole() async {
    setState(() => _isLoading = true);
    final phoneNumber = _phoneController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    // التحقق من صحة رقم الهاتف
    if (!_isValidLibyanPhoneNumber(phoneNumber)) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال رقم هاتف ليبي صحيح (91، 92، 94) متبوعًا بسبعة أرقام.')),
      );
      return;
    }

    try {
      // التحقق إذا كان المستخدم موجودًا في Firestore
      final userDoc = await _firestore.collection('users').doc(phoneNumber).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData['role'] == 'admin') {
          // إذا كان المستخدم أدمن، الانتقال إلى واجهة الأدمن
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else {
          // إذا كان مستخدمًا عاديًا، إرسال رمز التحقق
          _sendOtp(phoneNumber);
        }
      } else {
        // إذا لم يكن المستخدم موجودًا، إرسال رمز التحقق
        _sendOtp(phoneNumber); 
      }
    } catch (e) {
      print("خطأ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التحقق من المستخدم.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // إرسال رمز التحقق OTP
  void _sendOtp(String phoneNumber) async {
    try {
      // إزالة البادئة "0" من الرقم المحلي
      String formattedPhoneNumber = phoneNumber.startsWith('0')
          ? phoneNumber.substring(1)
          : phoneNumber;

      // إرسال الرقم إلى Firebase مع بادئة الدولة
      await _auth.verifyPhoneNumber(
        phoneNumber: '+218$formattedPhoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _saveUserData();
          Navigator.pushReplacementNamed(context, '/user_dashboard');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('فشل التحقق: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل التحقق: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => _verificationId = verificationId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: formattedPhoneNumber,
                onVerified: _saveUserData,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _verificationId = verificationId);
        },
      );
    } catch (e) {
      print('خطأ في إرسال OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إرسال رمز التحقق.')),
      );
    }
  }

  // حفظ بيانات المستخدم الجديد في Firestore
  void _saveUserData() async {
    final phoneNumber = _phoneController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    try {
      await _firestore.collection('users').doc(phoneNumber).set({
        'userId': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'walletBalance': 0.0,
        'role': 'user', // يتم تعيين الدور للمستخدم هنا كـ "user"
      });
    } catch (e) {
      print("خطأ في حفظ البيانات: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في حفظ بيانات المستخدم.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أهلًا بك!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'الاسم الأول'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'الاسم الأخير'),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'رقم الهاتف الليبي (بدون +218)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _checkUserRole,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



