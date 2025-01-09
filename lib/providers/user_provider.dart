import 'dart:convert'; // لتحويل الصورة إلى Base64
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserModel> _users = [];
  UserModel? _currentUser;

  // Getters
  UserModel? get currentUser => _currentUser;
  List<UserModel> get users => _users;

  // تحميل بيانات المستخدم من Firestore
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        final snapshot = await _firestore.collection('users').doc(userId).get();
        if (snapshot.exists) {
          _currentUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }
  }


  Future<void> remove(String userid) async {
    try {
      await _firestore.collection('users').doc(userid).delete();
        notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }

  // حفظ بيانات المستخدم في SharedPreferences
  Future<void> _saveUserLocally(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId);
  }

  // تسجيل الدخول
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        final snapshot = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (snapshot.exists) {
          UserModel user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          _currentUser = user;
          await _saveUserLocally(user);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }

  // تسجيل مستخدم جديد
  Future<void> signUp(String email, String password, String firstName, String lastName, String phoneNumber) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          userId: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: 'مستخدم',
          walletBalance: 0.0,
          profileImageBase64: null,
          phoneNumber: phoneNumber,
          passwordHash: '',
        );
        await _firestore.collection('users').doc(newUser.userId).set(newUser.toMap());
        _currentUser = newUser;
        await _saveUserLocally(newUser);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Sign Up error: $e');
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  // تحديث بيانات المستخدم
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.email).update(updatedUser.toMap());
      if (_currentUser != null && _currentUser!.userId == updatedUser.userId) {
        _currentUser = updatedUser;
        await _saveUserLocally(updatedUser);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }

  // جلب جميع المستخدمين
  Future<void> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      notifyListeners();
    }
    catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  Future<List<UserModel>?> search(String query) async {
    print("Getting users");
    // try {
      final snapshot = await _firestore.collection('users')
      .where(
          Filter.or(
            Filter("firstName", isGreaterThanOrEqualTo: query),
          Filter("lastName", isGreaterThanOrEqualTo: query),
          Filter("phone", isGreaterThanOrEqualTo: query),
          Filter("email", isGreaterThanOrEqualTo: query),
          )
    )
          .get();

      print(snapshot.size);

      var users = snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      notifyListeners();
      return users;
    // }
    // catch (e) {
    //   debugPrint('Error fetching users: $e');
    // }

    return null;
  }
}
