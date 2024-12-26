import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  OTPScreen({
    required this.verificationId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // You have an issue at this line
      // cannot route
      // You should add route for client, owner, and admin
      if (userCredential.user != null) {
        await _handleUserRole(widget.phoneNumber);
      }
    } catch (e) {
      print(e);
      print("***************************");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("رمز التحقق غير صحيح")),
      );
    }
  }

  Future<void> _handleUserRole(String phoneNumber) async {
    final userDoc =
    await _firestore.collection('users').doc(phoneNumber).get();

    if (userDoc.exists) {
      String role = userDoc.data()?['role'];
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/carDisplay');
      } else if (role == 'owner') {
        Navigator.pushReplacementNamed(context, '/ownerHome');
      } else {
        Navigator.pushReplacementNamed(context, '/myAccount');
      }
    } else {
      await _firestore.collection('users').doc(phoneNumber).set({
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'phoneNumber': widget.phoneNumber,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, '/userHome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("التحقق من OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "أدخل رمز OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: Text("تحقق"),
            ),
          ],
        ),
      ),
    );
  }
}
