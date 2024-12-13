import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  String _selectedRole = 'User'; // الدور الافتراضي
  String verificationId = ''; // معرف التحقق للOTP
  bool isOtpSent = false; // لتحديد ما إذا تم إرسال OTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل إدخال الاسم
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            // حقل إدخال رقم الهاتف
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            // قائمة منسدلة لاختيار الدور
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'User', child: Text('User')),
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                DropdownMenuItem(value: 'Owner', child: Text('Owner')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            // حقل إدخال رمز التحقق
            TextField(
              controller: _verificationCodeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
            ),
            const SizedBox(height: 20),
            // زر لإرسال OTP
            ElevatedButton(
              onPressed: _sendOtp, // استدعاء وظيفة إرسال OTP
              child: const Text('Send OTP'),
            ),
            const SizedBox(height: 10),
            // زر لإضافة المستخدم بعد التحقق من OTP
            ElevatedButton(
              onPressed: isOtpSent ? _verifyOtp : null, // تفعيل الزر فقط بعد إرسال OTP
              child: const Text('Verify and Add User'),
            ),
          ],
        ),
      ),
    );
  }

  // وظيفة لإرسال OTP إلى رقم الهاتف المحدد
  Future<void> _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();
    // إذا كان الرقم لا يبدأ بـ "+" أو برمز الدولة، أضف رمز الدولة تلقائيًا
    if (!phoneNumber.startsWith('+218')) {
      phoneNumber = '+218$phoneNumber';
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // تسجيل الدخول التلقائي إذا تم التحقق بنجاح
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          if (userCredential.user != null) {
            // إضافة المستخدم إلى قاعدة البيانات بعد التحقق
            await _addUserToFirestore(userCredential.user!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully!')));
            Navigator.pop(context); // العودة للصفحة السابقة
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // التعامل مع الأخطاء عند فشل عملية التحقق
          print('Verification failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed')));
        },
        codeSent: (String verificationId, int? resendToken) {
          // حفظ معرف التحقق وإعداد الحالة لإظهار حقل OTP
          setState(() {
            this.verificationId = verificationId;
            isOtpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // إدارة وقت انتهاء صلاحية التحقق التلقائي (اختياري)
        },
      );
    } catch (e) {
      // التعامل مع الأخطاء العامة أثناء إرسال OTP
      print('Error sending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending OTP')));
    }
  }

  // وظيفة للتحقق من OTP الذي أدخله الأدمن
  Future<void> _verifyOtp() async {
    if (verificationId.isEmpty) {
      // تحقق إذا لم يتم إرسال OTP
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP not sent')));
      return;
    }

    try {
      // إنشاء credential باستخدام معرف التحقق ورمز OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _verificationCodeController.text.trim(),
      );

      // التحقق من OTP وتسجيل الدخول باستخدامه
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        // إضافة المستخدم إلى قاعدة البيانات بعد التحقق بنجاح
        await _addUserToFirestore(userCredential.user!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully!')));
        Navigator.pop(context); // العودة للصفحة السابقة
      }
    } catch (e) {
      // التعامل مع الأخطاء عند التحقق من OTP
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  // وظيفة لإضافة المستخدم إلى قاعدة بيانات Firestore
  Future<void> _addUserToFirestore(User user) async {
    try {
      // إضافة المستخدم إلى قاعدة بيانات Firestore مع التفاصيل المدخلة
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'phone': user.phoneNumber,
        'role': _selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // التعامل مع الأخطاء عند إضافة المستخدم إلى Firestore
      print('Error adding user to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user to database')));
    }
  }
}
