import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;

  // Getter للمستخدم الحالي
  UserModel? get currentUser => _currentUser;
  User? get firebaseUser => _auth.currentUser;

  // جلب المستخدم الحالي من Firestore بناءً على UID
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      // try {
        final snapshot = await _firestore.collection('users').doc(user.email).get();
        if (snapshot.exists) {
          _currentUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          return _currentUser;
          notifyListeners();
        }
      // } catch (e) {
      //   debugPrint('Error fetching current user: $e');
      // }
    }
    return null;
  }

  // تحديث بيانات المستخدم في Firestore والمزود
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.userId).update(updatedUser.toMap());
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }

  // تسجيل خروج المستخدم
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
