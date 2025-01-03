import 'dart:convert'; // لتحويل الصورة إلى Base64
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';  // تأكد من استيراد النموذج الخاص بك

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserModel> _users = [];
  String verificationId = '';
  bool isOtpSent = false;

  // Getter لإرجاع قائمة المستخدمين
  List<UserModel> get users => _users;

  // جلب جميع المستخدمين من Firestore
  Future<void> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
    catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  // إضافة مستخدم جديد إلى Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toMap());
      _users.add(user);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding user: $e');
    }
  }

  // دالة لإرسال OTP إلى رقم الهاتف
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+218$phoneNumber', // إضافة رمز الدولة
        verificationCompleted: (PhoneAuthCredential credential) async {
          // تسجيل الدخول التلقائي إذا تم التحقق بنجاح
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            await _addUserToFirestore(userCredential.user!);
            notifyListeners();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          isOtpSent = true;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Code auto-retrieval timed out');
        },
      );
    } catch (e) {
      debugPrint('Error sending OTP: $e');
    }
  }

  // دالة للتحقق من OTP المدخل
  Future<void> verifyOtp(String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _addUserToFirestore(userCredential.user!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
    }
  }

  // دالة لإضافة المستخدم إلى قاعدة بيانات Firestore
  Future<void> _addUserToFirestore(User user) async {
    try {
      UserModel newUser = UserModel(
        firstName: 'Default First Name', // تأكد من أن لديك اسم للمستخدم
        lastName: 'Default Last Name',
        phoneNumber: user.phoneNumber ?? '', // تأكد من وجود رقم الهاتف
        userId: user.uid, // معرّف المستخدم
        walletBalance: 0.0, // رصيد المحفظة الافتراضي
        profileImageBase64: null, // في البداية لا يوجد صورة
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding user to Firestore: $e');
    }
  }

  // دالة لرفع صورة المستخدم وتخزينها كـ Base64 في Firestore
  Future<void> uploadProfileImage(String userId) async {
    try {
      // اختيار صورة من المعرض أو الكاميرا
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // تحويل الصورة إلى Base64
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);

        // تحديث الرابط في Firestore
        await _firestore.collection('users').doc(userId).update({
          'profileImageBase64': base64String,
        });

        // تحديث الصورة في النموذج
        final updatedUser = _users.firstWhere((user) => user.userId == userId);
        final updatedUserWithNewImage = updatedUser.copyWith(profileImageBase64: base64String);

        // تحديث القائمة
        int index = _users.indexOf(updatedUser);
        _users[index] = updatedUserWithNewImage;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
    }
  }

  // دالة لحذف الصورة من Firestore
  Future<void> deleteProfileImage(String userId) async {
    try {
      // إزالة الصورة من Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageBase64': FieldValue.delete(), // حذف الصورة
      });

      // تحديث الصورة في النموذج
      final updatedUser = _users.firstWhere((user) => user.userId == userId);
      final updatedUserWithoutImage = updatedUser.copyWith(profileImageBase64: null);

      // تحديث القائمة
      int index = _users.indexOf(updatedUser);
      _users[index] = updatedUserWithoutImage;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting profile image: $e');
    }
  }
}
