/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String verificationId = "";

  bool isOtpSent = false;

  // إرسال OTP عند الضغط على "التالي"
  void _sendOtp() {
    final phoneNumber = _phoneController.text;
    AuthService().sendOTP(phoneNumber, (PhoneAuthCredential credential) {
      setState(() {
        verificationId = credential.verificationId ?? "";
        isOtpSent = true;
      });
    });
  }

  // التحقق من OTP عند الضغط على "تأكيد"
  void _verifyOtp() async {
    final otp = _otpController.text;
    User? user = await AuthService().signInWithOTP(otp, verificationId);
    if (user != null) {
      // إذا تم التحقق بنجاح، يمكنك الانتقال إلى الشاشة الرئيسية
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isOtpSent)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: 'Enter phone number'),
                keyboardType: TextInputType.phone,
              ),
            if (isOtpSent)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(hintText: 'Enter OTP'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}*/
