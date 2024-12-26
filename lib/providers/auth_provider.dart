import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // للمستخدم الحالي
  User? _currentUser;
  User? get currentUser => _currentUser;

  String _role = ''; // دور المستخدم (admin, owner, user)
  String get role => _role;

  bool _isAuthenticated = false; // حالة التوثيق
  bool get isAuthenticated => _isAuthenticated;

  // التوثيق باستخدام OTP
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("فشل التحقق: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        // يمكنك إرسال verificationId إلى شاشة OTP
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  String _verificationId = '';

  // التحقق من OTP
  Future<void> verifyOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _currentUser = userCredential.user;
        await _handleUserRole(userCredential.user!.phoneNumber!);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      print("رمز التحقق غير صحيح: $e");
      throw Exception("رمز التحقق غير صحيح");
    }
  }

  // التعامل مع دور المستخدم بعد التحقق
  Future<void> _handleUserRole(String phoneNumber) async {
    final userDoc = await _firestore.collection('users').doc(phoneNumber).get();

    if (userDoc.exists) {
      _role = userDoc.data()?['role'] ?? '';
    } else {
      // إذا لم يكن المستخدم موجودًا في Firestore، أضفه كـ "مستخدم" جديد
      await _firestore.collection('users').doc(phoneNumber).set({
        'firstName': '',
        'lastName': '',
        'phoneNumber': phoneNumber,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      _role = 'user';
    }
    notifyListeners();
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _role = '';
    _isAuthenticated = false;
    notifyListeners();
  }

  // التحقق من وجود المستخدم في قاعدة البيانات
  Future<bool> checkIfUserExists(String phoneNumber) async {
    try {
      var userDoc = await _firestore.collection('users').doc(phoneNumber).get();
      return userDoc.exists;
    } catch (e) {
      print("خطأ في التحقق من وجود المستخدم: $e");
      return false;
    }
  }
}
