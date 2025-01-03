import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({Key? key}) : super(key: key);

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  final user = FirebaseAuth.instance.currentUser; // المستخدم الحالي
  File? _image; // لحفظ الصورة المؤقتة
  final picker = ImagePicker();
  String? imageUrl;

  final _passwordController = TextEditingController(); // حقل الرقم السري الجديد

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<void> _uploadImage() async {
    if (_image == null) return;
    // TODO: Migrate to Supabase
    // final storageRef = FirebaseStorage.instance.ref().child('owner_images/${user?.uid}.jpg');

    // await storageRef.putFile(_image!);
    // final url = await storageRef.getDownloadURL();
    // setState(() {
    //   imageUrl = url;
    // });
  }

  // تغيير الرقم السري
  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty) return;

    try {
      await user?.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تغيير الرقم السري بنجاح')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تغيير الرقم السري')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('معلومات المالك'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // صورة المالك
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : AssetImage('assets/default_avatar.png') as ImageProvider,
                  child: _image == null ? Icon(Icons.camera_alt) : null,
                ),
              ),
              SizedBox(height: 20),

              // تفاصيل المالك
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text('البريد الإلكتروني'),
                      subtitle: Text(
                        user?.email ?? 'لا يوجد بريد مسجل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lock, color: Colors.orange),
                      title: Text('تغيير الرقم السري'),
                      subtitle: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور الجديدة',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // زر تغيير الرقم السري
              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: Icon(Icons.save),
                label: Text('تغيير الرقم السري'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
