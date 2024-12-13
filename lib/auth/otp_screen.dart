import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final VoidCallback onVerified;

  OtpScreen({
    required this.verificationId,
    required this.phoneNumber,
    required this.onVerified,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isResending = false;
  late String _verificationId;  // متغير محلي لحفظ verificationId

  @override
  void initState() {
    super.initState();
    // تعيين _verificationId بالقيمة المبدئية من widget
    _verificationId = widget.verificationId;
  }

  // إعادة إرسال رمز التحقق
  void _resendOtp() async {
    setState(() => _isResending = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+218${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          widget.onVerified();
          Navigator.pushReplacementNamed(context, '/user_dashboard');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('فشل التحقق: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل التحقق: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;  // تحديث _verificationId
            _isResending = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إعادة إرسال رمز التحقق.')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      print('خطأ في إعادة الإرسال: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إعادة إرسال الرمز.')),
      );
    }
  }

  // التحقق من رمز OTP
  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      widget.onVerified();
      Navigator.pushReplacementNamed(context, '/user_dashboard');
    } catch (e) {
      print('خطأ في التحقق من OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('رمز التحقق غير صحيح.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التحقق من الرمز'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تم إرسال رمز التحقق إلى الرقم ${widget.phoneNumber}',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'أدخل رمز التحقق',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('التحقق'),
            ),
            SizedBox(height: 20),
            _isResending
                ? CircularProgressIndicator()
                : TextButton(
              onPressed: _resendOtp,
              child: Text('إعادة إرسال الرمز'),
            ),
          ],
        ),
      ),
    );
  }
}
