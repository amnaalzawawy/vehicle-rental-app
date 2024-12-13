import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  OTPScreen({required this.phoneNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorMessage;
  String? _verificationId;
  bool _isResendingOTP = false;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  // إرسال OTP عند بدء الشاشة
  Future<void> _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // إذا تم التحقق تلقائيًا، سيتم تسجيل الدخول مباشرة
        await FirebaseAuth.instance.signInWithCredential(credential);
        _saveUserData();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _errorMessage = 'فشل في إرسال OTP: ${e.message}';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // التحقق من OTP
  Future<void> _verifyOTP() async {
    String otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      setState(() {
        _errorMessage = 'الرجاء إدخال رمز OTP بشكل صحيح';
      });
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: otp);

      await FirebaseAuth.instance.signInWithCredential(credential);
      _saveUserData();
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في التحقق من الرمز: ${e.toString()}';
      });
    }
  }

  // حفظ بيانات المستخدم بعد التحقق من OTP
  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // توجيه المستخدم إلى الشاشة الرئيسية
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // وظيفة إعادة إرسال OTP
  Future<void> _resendOTP() async {
    setState(() {
      _isResendingOTP = true;
    });

    await _sendOTP();

    setState(() {
      _isResendingOTP = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال OTP جديد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أدخل رمز التحقق')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'رمز التحقق (OTP)',
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: Text('تحقق'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isResendingOTP ? null : _resendOTP,  // تعطيل الزر أثناء إعادة الإرسال
              child: _isResendingOTP ? CircularProgressIndicator() : Text('إعادة إرسال OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
