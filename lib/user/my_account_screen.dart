import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/user.dart';
import '../providers/user_provider.dart';
import '../providers/current_user_provider.dart' as CurrentUserProvider;
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom_user_drawer.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profileImageBase64;
  int _selectedIndex = 0;
  bool _isEditingFirstName = false;
  bool _isEditingLastName = false;
  bool _isEditingPhone = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();

    var userProvider = CurrentUserProvider.UserProvider();

    userProvider.getCurrentUser().then((value) {
      setState(() {
        user = value;
      });

      setState(() {
        _firstNameController.text = value?.firstName ?? '';
        _lastNameController.text = value?.lastName ?? '';
        _phoneController.text = value?.phoneNumber ?? '';
        _profileImageBase64 = user?.profileImageBase64;
      });
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user != null) {
      setState(() {
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
        _phoneController.text = user.phoneNumber ?? '';
        _profileImageBase64 = user.profileImageBase64;
      });
    }
  }

  bool _hasChanges() {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) return false;
    return _firstNameController.text != user.firstName ||
        _lastNameController.text != user.lastName ||
        _phoneController.text != user.phoneNumber ||
        _profileImageBase64 != user.profileImageBase64;
  }

  Future<String> _convertImageToBase64(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي'),
        backgroundColor: const Color(0xFFF78B00),
        elevation: 0,
      ),
      drawer: CustomDrawer2(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,  // محاذاة العناصر إلى اليمين
            children: [
              const SizedBox(height: 100,),
              Text(
                'البريد الإلكتروني',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              Text(
                user?.email ?? " -- ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),

              // الاسم الأول
              Row(
                mainAxisAlignment: MainAxisAlignment.start,  // محاذاة الأيقونة إلى اليسار
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFFF78B00)),
                    onPressed: () {
                      setState(() {
                        _isEditingFirstName = true;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'الاسم الأول',
                      textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              _isEditingFirstName
                  ? TextField(
                controller: _firstNameController,
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك الأول',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
                  : Text(
                _firstNameController.text,
                textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // الاسم الأخير
              Row(
                mainAxisAlignment: MainAxisAlignment.start,  // محاذاة الأيقونة إلى اليسار
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFFF78B00)),
                    onPressed: () {
                      setState(() {
                        _isEditingLastName = true;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'الاسم الأخير',
                      textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              _isEditingLastName
                  ? TextField(
                controller: _lastNameController,
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك الأخير',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF78B00)),
                  ),
                ),
              )
                  : Text(
                _lastNameController.text,
                textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // رقم الهاتف
              Row(
                mainAxisAlignment: MainAxisAlignment.start,  // محاذاة الأيقونة إلى اليسار
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFFF78B00)),
                    onPressed: () {
                      setState(() {
                        _isEditingPhone = !_isEditingPhone;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'رقم الهاتف',
                      textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              _isEditingPhone
                  ? TextField(
                controller: _phoneController,
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                decoration: InputDecoration(
                  hintText: 'أدخل رقم هاتفك',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF78B00)),
                  ),
                ),
              )
                  : Text(
                _phoneController.text,
                textAlign: TextAlign.right,  // محاذاة النص إلى اليمين
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // زر حفظ التغييرات
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (user != null) {
                      final updatedUser = user?.copyWith(
                        firstName: _firstNameController.text.isNotEmpty ? _firstNameController.text : user?.firstName,
                        lastName: _lastNameController.text.isNotEmpty ? _lastNameController.text : user?.lastName,
                        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : user?.phoneNumber,
                      );
                      if (updatedUser != null) {
                        await Provider.of<UserProvider>(context, listen: false).updateUser(updatedUser);
                      }
                      setState(() {
                        _isEditingFirstName = false;
                        _isEditingLastName = false;
                        _isEditingPhone = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF78B00),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'حفظ التغييرات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // زر تسجيل الخروج
              Center(
                child: TextButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
