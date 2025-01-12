import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // لاستعمال Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // لاستعمال Firestore
import '../models/user.dart'; // استيراد نموذج المستخدم

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false; // حالة تسجيل الدخول للمستخدم
  String _role = ''; // دور المستخدم (admin, user)
  UserModel? _currentUser; // بيانات المستخدم الحالي
  String _verificationId = ''; // معرف التحقق (Verification ID)

  // Getter للحصول على حالة التسجيل
  bool get isAuthenticated => _isAuthenticated;

  // Getter للحصول على دور المستخدم
  String get role => _role;

  // Getter للحصول على بيانات المستخدم الحالي
  UserModel? get currentUser => _currentUser;

  // التحقق إذا كان المستخدم أدمن
  bool get isAdmin => _role == 'admin';

  // التحقق إذا كان المستخدم مستخدم نهائي
  bool get isUser => _role == 'user';

  // تسجيل الدخول باستخدام رقم الهاتف والدور
  Future<void> loginWithPhone(String phoneNumber, String role) async {
    try {
      // بدء عملية التحقق باستخدام Firebase
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+218${phoneNumber}', // إضافة رمز الدولة
        verificationCompleted: (PhoneAuthCredential credential) async {
          // إذا تم التحقق تلقائيًا، تسجيل الدخول مباشرة
          await FirebaseAuth.instance.signInWithCredential(credential);
          _currentUser = await fetchUserData(phoneNumber); // استرجاع بيانات المستخدم
          _isAuthenticated = true;
          _role = role.toLowerCase(); // تعيين الدور بناءً على الاختيار
          notifyListeners(); // إعلام المستمعين لتحديث الواجهة
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            print("فشل التحقق: ${e.message}");
          }
          throw Exception("فشل التحقق: ${e.message}"); // إعادة الخطأ في حالة الفشل
        },
        codeSent: (String verificationId, int? resendToken) {
          // حفظ معرف التحقق (Verification ID) لإدخاله في التحقق من OTP
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // حفظ معرف التحقق في حالة انتهاء المهلة
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في تسجيل الدخول: $e");
      }
      throw Exception("حدث خطأ أثناء عملية التحقق.");
    }
  }

  // التحقق من OTP
  Future<void> verifyOtp(String otp) async {
    try {
      // استخدام معرف التحقق للتحقق من OTP المدخل
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // تسجيل الدخول باستخدام الـ OTP
      await FirebaseAuth.instance.signInWithCredential(credential);
      _currentUser = await fetchUserData(FirebaseAuth.instance.currentUser!.phoneNumber!); // استرجاع بيانات المستخدم
      _isAuthenticated = true;
      notifyListeners(); // إعلام المستمعين لتحديث الواجهة
    } catch (e) {
      print("خطأ في التحقق من OTP: $e");
      throw Exception("رمز التحقق غير صحيح.");
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut(); // تسجيل الخروج من Firebase
    _isAuthenticated = false; // تغيير حالة التسجيل إلى غير مسجل
    _role = ''; // إعادة تعيين الدور
    _currentUser = null; // مسح بيانات المستخدم
    notifyListeners(); // إعلام المستمعين بالتحديث
  }

  // دالة لاسترجاع بيانات المستخدم من Firestore
  Future<UserModel> fetchUserData(String phoneNumber) async {
    try {
      // استرجاع بيانات المستخدم من Firestore باستخدام رقم الهاتف
      var userData = await FirebaseFirestore.instance
          .collection('users') // التأكد من أن المجموعة في Firestore هي 'users'
          .doc(phoneNumber) // استخدام رقم الهاتف كمفتاح للمستند
          .get(); // جلب البيانات

      // تحويل البيانات من Firestore إلى كائن من نوع UserModel
      return UserModel.fromMap(userData.data()!);
    } catch (e) {
      print("خطأ في استرجاع البيانات: $e");
      rethrow; // إعادة الخطأ إذا فشل استرجاع البيانات
    }
  }

  // تحديث بيانات المستخدم الحالي
  void updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser; // تعيين المستخدم المحدث
    notifyListeners(); // إعلام المستمعين بالتحديث
  }
}
