import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/bottom_navigation_bar.dart';  // استيراد الشريط السفلي

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _profileImageBase64;
  int _selectedIndex = 0;  // الفهرس المختار في الشريط السفلي

  @override
  void initState() {
    super.initState();
    // قم بتحديث القيم من مزود البيانات
    final user = Provider.of<UserProvider>(context, listen: false).users.firstWhere((user) => user.userId == 'currentUserId'); // استخدم معرّف المستخدم الحالي
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _profileImageBase64 = user.profileImageBase64;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).users.firstWhere((user) => user.userId == 'currentUserId'); // استخدم معرّف المستخدم الحالي

    return Scaffold(
      appBar: AppBar(
        title: Text('حسابي'),
        backgroundColor: Color(0xFFF78B00), // اللون البرتقالي المميز
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض الصورة الشخصية
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // اختيار صورة جديدة
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final base64String = await _convertImageToBase64(pickedFile.path);
                      await Provider.of<UserProvider>(context, listen: false).uploadProfileImage(user.userId);
                    }
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _profileImageBase64 != null
                        ? MemoryImage(base64Decode(_profileImageBase64!))
                        : AssetImage('assets/images/default_profile.png') as ImageProvider,
                    child: _profileImageBase64 == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // الاسم الأول
              Text(
                'الاسم الأول',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك الأول',
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFF78B00)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // الاسم الأخير
              Text(
                'الاسم الأخير',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك الأخير',
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFF78B00)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // رقم الهاتف (عرض فقط)
              Text(
                'رقم الهاتف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              TextFormField(
                initialValue: user.phoneNumber,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 20),

              // زر حفظ التغييرات
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final updatedUser = user.copyWith(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                    );
                    await Provider.of<UserProvider>(context, listen: false).addUser(updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF78B00), // اللون البرتقالي
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'حفظ التغييرات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // زر لحذف الصورة الشخصية
              if (_profileImageBase64 != null)
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<UserProvider>(context, listen: false).deleteProfileImage(user.userId);
                      setState(() {
                        _profileImageBase64 = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم حذف الصورة بنجاح!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // اللون الأحمر لحذف الصورة
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'حذف الصورة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // دالة لتحويل الصورة إلى Base64
  Future<String> _convertImageToBase64(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    return base64Encode(bytes);
  }
}
